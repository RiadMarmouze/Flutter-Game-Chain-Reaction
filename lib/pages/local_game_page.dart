import 'package:chain_reaction/providers/local_game_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chain_reaction/widgets/local_cell_animation.dart';
import 'package:chain_reaction/widgets/local_cell_widget.dart';

class LocalGamePage extends StatefulWidget {
  const LocalGamePage({Key? key}) : super(key: key);

  @override
  State<LocalGamePage> createState() => _LocalGamePageState();
}

class _LocalGamePageState extends State<LocalGamePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<LocalGameStateProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: gameState.room.currentPlayer.color,
        title: Text('Chain Reaction ${gameState.room.currentPlayer.username}'),
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
}

class BoardGrid extends StatefulWidget {
  const BoardGrid({Key? key}) : super(key: key);

  @override
  State<BoardGrid> createState() => _BoardGridState();
}

class _BoardGridState extends State<BoardGrid> {
  @override
  Widget build(BuildContext context) {
    final boardState = Provider.of<LocalGameStateProvider>(context);
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
    final boardState = Provider.of<LocalGameStateProvider>(context);
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
