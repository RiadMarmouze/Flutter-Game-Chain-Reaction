import 'package:chain_reaction/models/move.dart';
import 'package:chain_reaction/models/player.dart';
import 'package:chain_reaction/models/cell.dart';
import 'package:chain_reaction/models/roomLocal.dart';
import 'package:chain_reaction/services/database_room_service.dart';

class RoomOnline extends RoomLocal {
  // only online

  late final Player player;

  late final String id;

  late final Player host;
  late RoomService roomService;

  late bool startGame;
  late Move currentGamePlay;
  late List<bool> executeCurrentMoveState;

  late int joinedPlayers = 0;

  bool get isMyTurn => player.index == currentPlayer.index;

  RoomOnline.asHost({
    required this.host,
    required super.boardHeight,
    required super.boardWidth,
    required super.maxPlayers,
  }) {
    player = host;
    _initRoomDynamic();
    roomService = RoomService();
  }

  Future<void>? createRoomInFireBase() async {
    return await roomService.createRoomInFirebase(toMap(), setId);
  }

  Future<void>? loadRoomFromFireBase(String roomId) async {
    setId(roomId);
    roomService = RoomService(uid: roomId);
    return await roomService.loadRoomFromFirebase(setRoomValues);
  }

  void setId(String newId) {
    id = newId;
  }

  void setRoomValues(Map<String, dynamic> newRoomMap) {
    host = Player.fromMap(newRoomMap["static"]['host']);
    id = newRoomMap["static"]['id'] as String;
    boardHeight = newRoomMap["static"]['boardHeight'];
    boardWidth = newRoomMap["static"]['boardWidth'];
    maxPlayers = newRoomMap["static"]['maxPlayers'];
    
    setAllPlayers((newRoomMap["dynamic"]['setAllPlayers'] as List).map((player) => Player.fromMap(player)).toList());
    setRemainPlayers((newRoomMap["dynamic"]['remainPlayers'] as List).map((player) => Player.fromMap(player)).toList());
    setCurrentPlayerIndex(newRoomMap["dynamic"]['currentPlayerIndex']);

    setMatrixState((newRoomMap["dynamic"]['matrixState'] as List).map(
      (row) => (row as List).map(
        (cell) => Cell.fromMap(cell, boardHeight, boardWidth)
      ).toList()
    ).toList());
    
    endGame = newRoomMap["dynamic"]['endGame'];
    startGame = newRoomMap["dynamic"]['startGame'];
    gamePlayHistory = (newRoomMap["dynamic"]['gamePlay'] as List).map((move) => Move.fromMap(move)).toList();
    executeCurrentMoveState = (newRoomMap["dynamic"]["executeCurrentMoveState"] as List<bool>).map((e) => e).toList();
    currentGamePlay = Move.fromMap(newRoomMap["dynamic"]["currentGamePlay"]); 
  }

  RoomOnline({
    required this.player,
    required super.boardHeight,
    required super.boardWidth,
    required super.maxPlayers,
  }) {
    _initRoomDynamic();
  }

  Map<String, dynamic> roomDynamicToMap() {
    return {
      'joinedPlayers': joinedPlayers, 
      'allPlayers': allPlayers.map((player) => player.toMap()).toList(), 
      'remainPlayers': remainPlayers.map((player) => player.toMap()).toList(), 
      'currentPlayer': currentPlayer.toMap(), 
      'currentPlayerIndex': currentPlayerIndex, 
      'endGame': endGame, 
      'startGame': startGame, 
      'currentGamePlay': currentGamePlay.toMap(), 
      'executeCurrentMoveState': executeCurrentMoveState, 
      'gamePlayHistory': gamePlayHistory.map((move) => move.toMap()).toList(), 
      'matrixState': _removedPaddingMap(matrixState)
    };
  }

  Map<String, dynamic> roomStaticToMap() {
    return {
      // 'id': id,
      'host': host.toMap(),
      'boardHeight': boardHeight,
      'boardWidth': boardWidth,
      'maxPlayers': maxPlayers,
    };
  }

  Map<String, dynamic> toMap() {
    return {'static': roomStaticToMap(), 'dynamic': roomDynamicToMap()};
  }

  // static RoomOnline staticFromMap(Map<String, dynamic> map) {
  //   return RoomOnline(
  //     host: Player.fromMap(map['host']),
  //     boardHeight: map['boardHeight'],
  //     boardWidth: map['boardWidth'],
  //     maxPlayers: map['maxPlayers'],
  //   );
  // }

  List<List<Map<String, dynamic>>> _removedPaddingMap(List<List<Cell>> matrixState) {
    List<List<Map<String, dynamic>>> matrixStateList = [];

    // Start from the second row and end at the second-to-last row
    for (int i = 1; i < matrixState.length - 1; i++) {
      var row = matrixState[i];
      List<Map<String, dynamic>> rowList = [];
      // Start from the second element and end at the second-to-last element in each row
      for (int j = 1; j < row.length - 1; j++) {
        var cell = row[j];
        rowList.add(cell.toMap());
      }
      matrixStateList.add(rowList);
    }
    return matrixStateList;
  }

  void _initRoomDynamic() {
    setInitGenerateAllPlayersOnline();
    addToPlayers(host);
    setCurrentPlayerIndex(0);
    setJoinedPlayers(0);

    endGame = false;
    startGame = false;

    currentGamePlay = Move(row: -1, col: -1, playerindex: -1);
    gamePlayHistory.insert(0, currentGamePlay);

    executeCurrentMoveState = List.filled(maxPlayers, false);

    setInitGenerateMatrixState();
  }

  void setJoinedPlayers(int newVal) {
    joinedPlayers = newVal;
  }

  void addToPlayers(Player newPlayer) {
    if (joinedPlayers < maxPlayers) {
      allPlayers[newPlayer.index] = newPlayer;
      remainPlayers.add(newPlayer);
      joinedPlayers += 1;
    } else {
      print("the room is full");
    }
  }

  void moveToNewGamePlay() {
    gamePlayHistory.insert(0, currentGamePlay);
    currentGamePlay = Move(row: -1, col: -1, playerindex: -1);
    gamePlayHistory.insert(0, currentGamePlay);
  }

  // players infos

  void setInitGenerateAllPlayersOnline() {
    allPlayers = List.generate(maxPlayers, (index) {
      return Player.withId(id: "id", username: "player${index + 1}", index: index);
    });
  }

  // start/end game

  void setStartGame() {
    startGame = true;
  }

  // gameplay

  void setCurrentGamePlay(int row, int col) {
    Move newMove = Move(row: row, col: col, playerindex: currentPlayer.index);
    currentGamePlay = newMove;
  }

  void setGamePlayHistory(List<Move> newHistory) {
    gamePlayHistory = newHistory;
  }
}
