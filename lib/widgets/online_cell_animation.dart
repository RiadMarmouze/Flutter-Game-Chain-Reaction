import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chain_reaction/providers/local_game_state_provider.dart';


class CellAnimation extends StatefulWidget {
  final int row, col;
  final double cellSize;
  const CellAnimation(this.row,this.col,this.cellSize, {super.key});

  @override
  State<CellAnimation> createState() => _CellAnimationState();
}

class _CellAnimationState extends State<CellAnimation> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // _animation = Tween<double>(begin: 1, end: 0).animate(_controller);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // This curve starts and ends smoothly
    );

    _animation.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });

    // Listen for changes in the BoardStateProvider
    Provider.of<LocalGameStateProvider>(context, listen: false).addListener(_checkAnimation);
  }

  @override
  void dispose() {
    // Remove the listener
    Provider.of<LocalGameStateProvider>(context, listen: false).removeListener(_checkAnimation);
    _controller.dispose();
    super.dispose();
  }


  void _checkAnimation() {
    // Check if this cell needs animation
    if (Provider.of<LocalGameStateProvider>(context, listen: false).room.getCell(widget.row,widget.col).animeState == true) {
      // Start the animation
      _animate();
      // Reset the animation state for this cell
      Future.delayed(const Duration(seconds: 1), () {
        // Reset the animation state for this cell after the delay
        Provider.of<LocalGameStateProvider>(context, listen: false).resetAnimation(widget.row, widget.col);
      });
    }
  }

  Future<void> _animate() {
    if (_controller.status == AnimationStatus.completed || _controller.status == AnimationStatus.dismissed) {
      // If the animation is not currently running, start it from the beginning
      _controller.reset();
      return _controller.forward().then((_) {
        // Animation completes
      });
    } else {
      return Future.value(); // Animation is already running
    }
  }

  @override
  Widget build(BuildContext context) {

    final gameState = Provider.of<LocalGameStateProvider>(context);

    return gameState.room.getCell(widget.row,widget.col).animeState?
      SizedBox(
        height: widget.cellSize * 3,
        width: widget.cellSize * 3,
        child: Stack(
          children: [
            _animation.value != 0 &&
            gameState.room.getCell(widget.row,widget.col).getLeftAnime()
            ? Positioned(
              left: widget.cellSize * (1 - _animation.value),
              // left: 0,
              top: widget.cellSize,
              child: SizedBox(
                height: widget.cellSize,
                width: widget.cellSize,
                child: Image.asset(gameState.room.getAnimeCellPic(), fit: BoxFit.cover)
              ),
            )
            : const SizedBox(),
            _animation.value != 0 && 
            gameState.room.getCell(widget.row,widget.col).getRightAnime()
            ? Positioned(
              left: widget.cellSize + (widget.cellSize * _animation.value),
              // left: widget.cellSize * 2,
              top: widget.cellSize,
              child: SizedBox(
                height: widget.cellSize,
                width: widget.cellSize,
                child: Image.asset(gameState.room.getAnimeCellPic(), fit: BoxFit.cover)
              ),
            )
            : const SizedBox(),
            _animation.value != 0 && 
            gameState.room.getCell(widget.row,widget.col).getTopAnime()
            ? Positioned(
              left: widget.cellSize,
              top: widget.cellSize * (1 - _animation.value),
              // top: 0,
              child: SizedBox(
                height: widget.cellSize,
                width: widget.cellSize,
                child: Image.asset(gameState.room.getAnimeCellPic(), fit: BoxFit.cover)
              ),
            )
            : const SizedBox(),
            _animation.value != 0 && 
            gameState.room.getCell(widget.row,widget.col).getBottomAnime()
            ? Positioned(
              left: widget.cellSize,
              top: widget.cellSize + (widget.cellSize * _animation.value),
              // top: widget.cellSize * 2,
              child: SizedBox(
                height: widget.cellSize,
                width: widget.cellSize,
                child: Image.asset(gameState.room.getAnimeCellPic(), fit: BoxFit.cover)
              ),
            )
            : const SizedBox(),
          ],
        )
      ):const SizedBox();
  }
}
