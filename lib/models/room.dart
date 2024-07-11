import 'package:chain_reaction/models/move.dart';
import 'package:chain_reaction/models/player.dart';
import 'package:chain_reaction/models/cell.dart';

class Room {
  late String id;
  late Player host;
  late List<Player> allplayers;
  late List<int> remainplayersindexes;
  late List<List<Cell>> matrixState;
  late int currentplayerindex;

  bool endGame = false;
  bool startGame = false;

  List<Move> gamePlay = [];
  final int boardHeight;
  final int boardWidth;
  final int maxPlayers;

  int get nextplayerindex => (currentplayerindex + 1) % (remainplayersindexes.length);
  Player get currentplayer => allplayers[remainplayersindexes[currentplayerindex]];

  Room.online({required this.boardHeight, required this.boardWidth, required this.maxPlayers}) {
    int hostIndex = 0;
    host = Player(username: "player1(host)", index: hostIndex);
    currentplayerindex = host.index;

    allplayers = List.generate(maxPlayers, (index) {
      if (index == hostIndex) {
        return host;
      } else {
        return Player(username: "player${index + 1}(guest)", index: index);
      }
    });

    remainplayersindexes = List.generate(maxPlayers, (index) => index);

    matrixState = _generateMatrixState();
  }

  Room.local({required this.boardHeight, required this.boardWidth, required this.maxPlayers}) {
    allplayers = List.generate(maxPlayers, (index) {
      return Player(username: "player${index + 1}", index: index);
    });
    remainplayersindexes = List.generate(maxPlayers, (index) => index);
    currentplayerindex = 0;
    matrixState = _generateMatrixState();
  }

  Room.withValues({
    required this.id,
    required this.host,
    required this.allplayers,
    required this.remainplayersindexes,
    required this.currentplayerindex,
    required this.endGame,
    required this.startGame,
    required this.gamePlay,
    required this.boardHeight,
    required this.boardWidth,
    required this.maxPlayers,
    required List<List<Cell>> newMatrixState,
  }) {
    matrixState = _generateMatrixState();
    for (int row = 0; row < newMatrixState.length; row++) {
      for (int col = 0; col < newMatrixState[row].length; col++) {
        matrixState[row + 1][col + 1] = newMatrixState[row][col];
      }
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'host': host.toMap(),
      'allplayers': allplayers.map((player) => player.toMap()).toList(),
      'remainplayersindexes': remainplayersindexes.map((e) => e).toList(),
      'matrixState': _removedPaddingMap(matrixState),
      'currentplayerindex': currentplayerindex,
      'endgame': endGame,
      'startgame': startGame,
      'gamePlay': gamePlay.map((move) => move.toMap()).toList(),
      'boardHeight': boardHeight,
      'boardWidth': boardWidth,
      'maxPlayers': maxPlayers,
    };
  }

  static Room fromMap(Map<String, dynamic> map) {
    return Room.withValues(
      id: map['id'] as String,
      host: Player.fromMap(map['host']),
      allplayers: (map['allplayers'] as List).map((player) => Player.fromMap(player)).toList(),
      currentplayerindex: map['currentplayerindex'],
      remainplayersindexes: (map['remainplayersindexes'] as List).map((e) => e as int).toList(),
      newMatrixState: (map['matrixState'] as List).map((row) => (row as List).map((cell) => Cell.fromMap(cell, map['boardHeight'], map['boardWidth'])).toList()).toList(),
      endGame: map['endgame'],
      startGame: map['startgame'],
      gamePlay: (map['gamePlay'] as List).map((move) => Move.fromMap(move)).toList(),
      boardHeight: map['boardHeight'],
      boardWidth: map['boardWidth'],
      maxPlayers: map['maxPlayers'],
    );
  }

  // State functions

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

  List<List<Cell>> _generateMatrixState() {
    return List.generate(boardHeight + 2, (row) {
      return List.generate(boardWidth + 2, (col) {
        return Cell(row: row, col: col, boardHeight: boardHeight, boardWidth: boardWidth);
      });
    });
  }

  Cell getCell(int row, int col) {
    return matrixState[row][col];
  }

  void setCellDefault(int row, int col) {
    matrixState[row][col] = Cell(row: row, col: col, boardHeight: boardHeight, boardWidth: boardWidth);
  }

  void setEndGame() {
    endGame = true;
  }

  void addToCell(int row, int col) {
    matrixState[row][col].addToCell(currentplayer);
  }

  void updateRemainPlayersIndexes() {
    List<int> newRemainPlayers = [];
    for (var index in remainplayersindexes) {
      bool exist = false;
      int row = 0;
      while (row < matrixState.length && !exist) {
        int col = 0;
        while (col < matrixState[row].length && !exist) {
          if (matrixState[row][col].player == index) {
            newRemainPlayers.add(index);
            exist = true;
          }
          col++;
        }
        row++;
      }
    }
    remainplayersindexes = newRemainPlayers;
  }

  void swichTurn(int row, int col) {
    gamePlay.add(Move(row: row, col: col, playerindex: currentplayer.index));
    currentplayerindex = nextplayerindex;
  }

  bool isCanPlay(int row, int col) {
    return matrixState[row][col].isCanPlay(currentplayer);
  }

  bool isWin() {
    if (gamePlay.length > maxPlayers) {
      return (remainplayersindexes.length == 1);
    } else {
      return false;
    }
  }
  // Animation functions

  String getAnimeCellPic() {
    return "assets/player${currentplayer.index + 1}_1.png";
  }

  void setAnimeState(int row, int col, bool state) {
    matrixState[row][col].setAnimeState(state);
  }
}
