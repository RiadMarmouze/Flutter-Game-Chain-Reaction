import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chain_reaction/providers/local_game_state_provider.dart';

class CellWidget extends StatefulWidget {
  final int row, col;
  final double cellSize;
  const CellWidget(this.row, this.col, this.cellSize, {super.key});

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> with TickerProviderStateMixin {
  AnimationController? _controller;
  final Tween<double> _tween = Tween(begin: 0.75, end: 1);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _controller!.repeat(reverse: true);
    // Start listening to changes in gamePlay
    // Provider.of<GameStateProvider>(context, listen: false).listenToRoom();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<LocalGameStateProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        gameState.play(widget.row, widget.col);
        gameState.onGameCompletion = () {
          Navigator.pushNamed(context, '/endgame',arguments: gameState.room.remainPlayers[0],);
        };
      },
      child: Stack(
        children: [
          Container(
            height: widget.cellSize,
            width: widget.cellSize,
            decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: gameState.room.currentPlayer.color)),
            child: gameState.room.matrixState[widget.row][widget.col].pop
              ? ScaleTransition(
                  scale: _tween.animate(CurvedAnimation(parent: _controller!, curve: Curves.elasticOut)),
                  child: Center(child: !gameState.room.getCell(widget.row, widget.col).isCellEmpty() ? Image.asset(gameState.room.getCell(widget.row, widget.col).getCellPic(), fit: BoxFit.cover) : const SizedBox()),
                )
              : Center(child: !gameState.room.getCell(widget.row, widget.col).isCellEmpty() ? Image.asset(gameState.room.getCell(widget.row, widget.col).getCellPic(), fit: BoxFit.cover) : const SizedBox())),
          SizedBox(
            height: widget.cellSize,
            width: widget.cellSize,
            child: Center(child: Text("${gameState.room.getCell(widget.row, widget.col).state}",style: const TextStyle(color:Colors.white,fontSize: 20),)),
          )
        ],
      ),
    );
  }
}
