// import 'dart:async';

// import 'package:chain_reaction/models/move.dart';
// import 'package:chain_reaction/models/room.dart';
// import 'package:chain_reaction/models/player.dart';
// import 'package:chain_reaction/models/user.dart';

// import 'package:chain_reaction/services/database_room_service.dart';
// import 'package:flutter/material.dart';

// class GameStateProvider extends ChangeNotifier {
//   // TODO: solve the infinte loop when the explosion of the _explode function create a closed circle
//   //MAX_RECURSION_DEPTH = 6574
//   int maxRecursionDepth = 60;

//   List<List<int>> explodeCases = [
//     [0, -1],
//     [0, 1],
//     [-1, 0],
//     [1, 0]
//   ];

//   late bool online = false;
//   late User user;
//   late Player player = Player(index: 0, username: "Player0");
//   late RoomService roomService = RoomService(uid: "room123");

//   late Room room;
//   Function? onGameCompletion;

//   void updateGamePlay(Room newRoom) {
//     room = newRoom;
//     notifyListeners();
//   }

//   void setOnline(bool newValue) {
//     online = newValue;
//     notifyListeners();
//   }

//   void listenToRoom() {
//     roomService.listenToRoom((updatedRoom) {
//       room = updatedRoom;
//       notifyListeners();
//     });
//   }

//   GameStateProvider() {
//     if (online) {
//       room = Room.online(boardHeight: 10, boardWidth: 6, maxPlayers: 2);
//     } else {
//       room = Room.local(boardHeight: 10, boardWidth: 6, maxPlayers: 2);
//     }
//   }

//   // Change state room functions

//   void _addToCell(int row, col) {
//     room.addToCell(row, col);
//     notifyListeners();
//   }

//   void _setCellDefault(int row, col) {
//     room.setCellDefault(row, col);
//     notifyListeners();
//   }

//   Future<void> _explode(int row, col, {int depth = 0}) async {
//     if (depth > maxRecursionDepth || room.getCell(row, col).isCellPadding()) {
//       return;
//     }

//     if (!room.getCell(row, col).pop) {
//       _addToCell(row, col);
//       return;
//     }

//     _setCellDefault(row, col);

//     if (!room.getCell(row, col).isAnimating()) {
//       triggerAnimation(row, col);
//     } else {
//       while (room.getCell(row, col).isAnimating()) {
//         await Future.delayed(const Duration(milliseconds: 100));
//       }
//       triggerAnimation(row, col);
//     }

//     while (room.getCell(row, col).isAnimating()) {
//       await Future.delayed(const Duration(milliseconds: 100));
//     }

//     List<Future> futures = [];
//     for (var d in explodeCases) {
//       if (!room.getCell(row + d[0], col + d[1]).pop) {
//         futures.insert(0, Future.microtask(() => _explode(row + d[0], col + d[1], depth: depth + 1)));
//       } else {
//         futures.add(Future.microtask(() => _explode(row + d[0], col + d[1], depth: depth + 1)));
//       }
//     }
//     await Future.wait(futures);
//   }

//   void _switchTurn(int row, col) {
//     room.swichTurn(row, col);
//     notifyListeners();
//   }

//   void play(int row, col) async {
//     bool canPlay = true;
//     if (online) {
//       if (canPlay) {
//         canPlay = await roomService.myTurn(player.index);
//         if (canPlay) {
//           canPlay = await roomService.areAllMovesExecuted();
//         }
//       }
//     } else {
//       canPlay = room.isCanPlay(row, col);
//     }
//     if (canPlay) {
//       if (online) {
//         Move newMove = Move(row: row, col: col, playerindex: room.currentplayerindex);
//         await roomService.addMove(newMove);
//       }
//       if (room.matrixState[row][col].pop) {
//         await _explode(row, col);
//       } else {
//         _addToCell(row, col);
//       }
//       room.updateRemainPlayersIndexes();
//       if (room.isWin()) {
//         onGameCompletion?.call();
//         room.setEndGame();
//       } else {
//         _switchTurn(row, col);
//       }
//     }
//   }

//   // Change animation room state functions

//   void triggerAnimation(int row, col) async {
//     room.setAnimeState(row, col, true);
//     notifyListeners();
//   }

//   void resetAnimation(int row, int col) async {
//     room.setAnimeState(row, col, false);
//     notifyListeners();
//   }
// }
