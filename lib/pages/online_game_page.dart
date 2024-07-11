import 'package:chain_reaction/providers/online_game_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chain_reaction/widgets/local_cell_animation.dart';
import 'package:chain_reaction/widgets/local_cell_widget.dart';

import '../helpers/helper_function.dart';

class OnlineGamePage extends StatefulWidget {
  final bool createRoom;
  const OnlineGamePage({required this.createRoom, Key? key}) : super(key: key);

  @override
  State<OnlineGamePage> createState() => _OnlineGamePageState();
}

class _OnlineGamePageState extends State<OnlineGamePage> {
  Future<void>? _fireBaseFuture;
  String? value;
  @override
  initState() {
    super.initState();

    if (widget.createRoom) {
      _fireBaseFuture = Provider.of<OnlineGameStateProvider>(context, listen: false).createRoomInFireBaseAndSetRoomIdInRoomInstance();
    } else {
      _fireBaseFuture = Provider.of<OnlineGameStateProvider>(context, listen: false).loadRoomFromFireBase();
    }
    setValue();
    // Start listening to changes in gamePlay
    // Provider.of<OnlineGameStateProvider>(context, listen: false).listenToRoom();
  }

  setValue() async {
    value = await HelperFunctions.getUserRoomIdFromSF();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fireBaseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for the future to complete
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any errors that occurred during the future
          return Center(child: Text('An error occurred: ${snapshot.error}',style: TextStyle(fontSize: 10),));
        } else {
          // Once the future is complete, build the rest of your UI
          final gameState = Provider.of<OnlineGameStateProvider>(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: gameState.room.currentPlayer.color,
              title: Text('Chain Reaction ${gameState.room.currentPlayer.username} $value'),
            ),
            backgroundColor: Colors.black,
            body: const SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: BoardGridAmination(),
                  ),
                  Center(child: BoardGrid()),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class BoardGrid extends StatefulWidget {
  const BoardGrid({Key? key}) : super(key: key);

  @override
  State<BoardGrid> createState() => _BoardGridState();
}

class _BoardGridState extends State<BoardGrid> {
  @override
  Widget build(BuildContext context) {
    final boardState = Provider.of<OnlineGameStateProvider>(context);
    int H = boardState.room.boardHeight;
    int W = boardState.room.boardWidth;
    double cellSize = (MediaQuery.sizeOf(context).height - 200) / H;
    return SizedBox(
      width: cellSize * W,
      height: cellSize * H,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: H,
          itemBuilder: (BuildContext listContext, int row) {
            return SizedBox(
              width: cellSize * W,
              height: cellSize,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: W,
                  itemBuilder: (BuildContext listContext, int col) {
                    return CellWidget(row + 1, col + 1, cellSize);
                  }),
            );
          }),
    );
  }
}

class BoardGridAmination extends StatefulWidget {
  const BoardGridAmination({Key? key}) : super(key: key);

  @override
  State<BoardGridAmination> createState() => _BoardGridAminationState();
}

class _BoardGridAminationState extends State<BoardGridAmination> {
  @override
  Widget build(BuildContext context) {
    final boardState = Provider.of<OnlineGameStateProvider>(context);
    int H = boardState.room.boardHeight;
    int W = boardState.room.boardWidth;
    double cellSize = (MediaQuery.sizeOf(context).height - 200) / H;

    return SizedBox(
      width: cellSize * W,
      height: cellSize * H,
      child: Stack(
        children: List.generate(H, (row) {
          return Positioned(
            top: cellSize * (row - 1),
            child: SizedBox(
              width: cellSize * W,
              height: cellSize * 3,
              child: Stack(
                children: List.generate(W, (col) {
                  return Positioned(left: cellSize * (col - 1), child: CellAnimation(row + 1, col + 1, cellSize));
                }),
              ),
            ),
          );
        }),
      ),
    );
  }
}
