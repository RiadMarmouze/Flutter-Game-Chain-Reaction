import 'package:chain_reaction/models/move.dart';
import 'package:chain_reaction/models/player.dart';
import 'package:chain_reaction/models/cell.dart';

class RoomLocal {
  late List<Player> allPlayers;
  late List<Player> remainPlayers;
  late int currentPlayerIndex;

  bool endGame = false;
  List<Move> gamePlayHistory = [];

  late List<List<Cell>> matrixState;

  late final int boardHeight;
  late final int boardWidth;
  late final int maxPlayers;

  int get nextPlayerIndex => (currentPlayerIndex + 1) % (remainPlayers.length);
  Player get nextPlayer => remainPlayers[nextPlayerIndex];
  Player get currentPlayer => remainPlayers[currentPlayerIndex];

  RoomLocal({
    required this.boardHeight,
    required this.boardWidth,
    required this.maxPlayers,
  }) {
    setInitPlayersInfosLocal();
    setInitGenerateMatrixState();
  }

  // players infos

  void setInitPlayersInfosLocal() {
    setInitGenerateAllPlayersLocal();
    setRemainPlayers(allPlayers);
    setCurrentPlayerIndex(0);
  }

  void setAllPlayers(List<Player> newAllPlayers) {
    allPlayers = newAllPlayers;
  }

  void setRemainPlayers(List<Player> newRemainPlayers) {
    remainPlayers = newRemainPlayers;
  }

  void setCurrentPlayerIndex(int newCurrentPlayerIndex) {
    currentPlayerIndex = newCurrentPlayerIndex;
  }

  void updateRemainPlayers() {
    List<Player> newRemainPlayers = [];
    for (var player in remainPlayers) {
      bool exist = false;
      int row = 0;
      while (row < matrixState.length && !exist) {
        int col = 0;
        while (col < matrixState[row].length && !exist) {
          if (matrixState[row][col].player == player.index) {
            newRemainPlayers.add(player);
            exist = true;
          }
          col++;
        }
        row++;
      }
    }
    setRemainPlayers(newRemainPlayers);
  }

  void swichTurn() {
    currentPlayerIndex = nextPlayerIndex;
  }

  void setInitGenerateAllPlayersLocal() {
    allPlayers = List.generate(maxPlayers, (index) {
      return Player(username: "player${index + 1}", index: index);
    });
  }

  bool isWin() {
    if (gamePlayHistory.length > maxPlayers) {
      return (remainPlayers.length == 1);
    } else {
      return false;
    }
  }

  // start/end game

  void setEndGame() {
    endGame = true;
  }

  // gameplay

  void addToGamePlayHistory(int row, int col) {
    Move newMove = Move(row: row, col: col, playerindex: currentPlayer.index);
    gamePlayHistory.insert(0, newMove);
  }

  // matrix cells state

  Cell getCell(int row, int col) {
    return matrixState[row][col];
  }

  void setDefaultCell(int row, int col) {
    matrixState[row][col] = Cell(row: row, col: col, boardHeight: boardHeight, boardWidth: boardWidth);
  }

  void addToCell(int row, int col) {
    matrixState[row][col].addToCell(currentPlayer);
  }

  bool isCanPlayInCell(int row, int col) {
    return matrixState[row][col].isCanPlay(currentPlayer);
  }

  // matrix state

  void setMatrixState(List<List<Cell>> newMatrixState){
    for (int row = 0; row < newMatrixState.length; row++) {
      for (int col = 0; col < newMatrixState[row].length; col++) {
        matrixState[row + 1][col + 1] = newMatrixState[row][col];
      }
    }
  }

  void setInitGenerateMatrixState() {
    matrixState = List.generate(boardHeight + 2, (row) {
      return List.generate(boardWidth + 2, (col) {
        return Cell(row: row, col: col, boardHeight: boardHeight, boardWidth: boardWidth);
      });
    });
  }

  // Animation functions

  String getAnimeCellPic() {
    return "assets/player${currentPlayer.index + 1}_1.png";
  }

  void setAnimeState(int row, int col, bool state) {
    matrixState[row][col].setAnimeState(state);
  }
}
