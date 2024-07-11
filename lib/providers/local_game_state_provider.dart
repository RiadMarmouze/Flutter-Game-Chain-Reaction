import 'dart:async';

import 'package:chain_reaction/models/roomLocal.dart';
import 'package:flutter/material.dart';

class LocalGameStateProvider extends ChangeNotifier {
  
  late int boardHeight;
  late int boardWidth;
  late int maxPlayers;
  late RoomLocal room;
  Function? onGameCompletion;

  LocalGameStateProvider() {
    boardHeight = 10;
    boardWidth = 6;
    maxPlayers = 2;
    room = RoomLocal(boardHeight: boardHeight, boardWidth: boardWidth, maxPlayers: maxPlayers);
  }

  // Change state room functions

  void _addToCell(int row, col) {
    room.addToCell(row, col);
    notifyListeners();
  }

  void _setDefaultCell(int row, col) {
    room.setDefaultCell(row, col);
    notifyListeners();
  }

  Future<void> _explode(int row, col, {int depth = 0}) async {
    // TODO: solve the infinte loop when the explosion of the _explode function create a closed circle
    //MAX_RECURSION_DEPTH = 6574
    int maxRecursionDepth = 60;

    List<List<int>> explodeCases = [
      [0, -1],
      [0, 1],
      [-1, 0],
      [1, 0]
    ];

    if (depth > maxRecursionDepth || room.getCell(row, col).isCellPadding()) {
      return;
    }

    if (!room.getCell(row, col).pop) {
      _addToCell(row, col);
      return;
    }

    _setDefaultCell(row, col);

    await triggerAnimation(row, col);

    List<Future> futures = [];
    for (var d in explodeCases) {
      if (!room.getCell(row + d[0], col + d[1]).isCellPop()) {
        futures.insert(0, Future.microtask(() => _explode(row + d[0], col + d[1], depth: depth + 1)));
      } else {
        futures.add(Future.microtask(() => _explode(row + d[0], col + d[1], depth: depth + 1)));
      }
    }
    await Future.wait(futures);
  }

  void _switchTurn() {
    room.swichTurn();
    notifyListeners();
  }

  void play(int row, col) async {
    bool canPlay = room.isCanPlayInCell(row, col);
    if (canPlay) {
      room.addToGamePlayHistory(row, col);
      if (room.getCell(row, col).isCellPop()) {
        await _explode(row, col);
        room.updateRemainPlayers();
      } else {
        _addToCell(row, col);
      }
      if (room.isWin()) {
        onGameCompletion?.call();
        room.setEndGame();
      } else {
        _switchTurn();
      }
    }
  }

  // Change animation room state functions

  Future<void> triggerAnimation(int row, col) async {
    if (room.getCell(row, col).isAnimating()) {
      while (room.getCell(row, col).isAnimating()) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
    room.setAnimeState(row, col, true);
    notifyListeners();
    while (room.getCell(row, col).isAnimating()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void resetAnimation(int row, int col) async {
    room.setAnimeState(row, col, false);
    notifyListeners();
  }
}
