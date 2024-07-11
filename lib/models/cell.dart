import 'package:chain_reaction/models/player.dart';

class Cell {
  static const int centerCell = 3;
  static const int edgeCell = 1;
  static const int cornerCell = 2;
  static const int paddingCell = 0;

  static const List<List<bool>> animeCases = [
    //left   top  right  bottom
    [false, false, true, true],
    [true, false, true, true],
    [true, false, false, true],
    [false, true, true, true],
    [true, true, true, true],
    [true, true, false, true],
    [false, true, true, false],
    [true, true, true, false],
    [true, true, false, false],
  ];

  // static const int boardHeight = 10;
  // static const int boardWidth = 6;

  int boardHeight = 10;
  int boardWidth = 6;

  int row;
  int col;
  late int state;
  late int player;
  late bool pop;
  late bool animeState;
  late final int popN;
  late final List<bool> animeCase;

  Cell({
    required this.row,
    required this.col,
    required this.boardHeight,
    required this.boardWidth,
    this.state = 0,
    this.player = -1,
    this.animeState = false
  }) {
    popN = _initPopN();
    animeCase = _initAnimeCase();
    pop = isCellPop();
  }


  Map<String, dynamic> toMap() {
    return {
      'row': row,
      'col': col,
      'state': state,
      'player': player,
      'animeState': animeState
    };
  }

  static Cell fromMap(Map<String, dynamic> map,int boardHeight,int boardWidth) {
    return Cell(
      row: map['row'],
      col: map['col'],
      boardHeight: boardHeight,
      boardWidth: boardWidth,
      state: map['state'],
      player: map['player'],
      animeState: map['animeState']
    );
  }

  bool _isCellCenter() {
    return col > 1 && col < boardWidth && row > 1 && row < boardHeight;
  }

  bool _isCellEdge() {
    return (col == 1 || col == boardWidth) && (row == 1 || row == boardHeight);
  }

  int _initPopN() {
    if (isCellPadding()) {
      return paddingCell;
    } else if (_isCellCenter()) {
      return centerCell;
    } else if (_isCellEdge()) {
      return edgeCell;
    } else {
      return cornerCell;
    }
  }

  List<bool> _initAnimeCase() {
    if (row == 1) {
      if (col == 1) {
        return animeCases[0];
      } else if (col == boardWidth) {
        return animeCases[2];
      } else {
        return animeCases[1];
      }
    } else if (row == boardHeight) {
      if (col == 1) {
        return animeCases[6];
      } else if (col == boardWidth) {
        return animeCases[8];
      } else {
        return animeCases[7];
      }
    } else {
      if (col == 1) {
        return animeCases[3];
      } else if (col == boardWidth) {
        return animeCases[5];
      } else {
        return animeCases[4];
      }
    }
  }

  bool getLeftAnime() {
    return animeCase[0];
  }

  bool getTopAnime() {
    return animeCase[1];
  }

  bool getRightAnime() {
    return animeCase[2];
  }

  bool getBottomAnime() {
    return animeCase[3];
  }

  void setAnimeState(bool newState) {
    animeState = newState;
  }

  void addToCell(Player currentplayer) {
    state += 1;
    player = currentplayer.index;
    pop = isCellPop();
  }

  bool isAnimating() {
    return animeState;
  }

  bool isCanPlay(Player currentplayer) {
    return player == currentplayer.index || isCellEmpty();
  }

  bool isCellEmpty() {
    return player == -1;
  }

  bool isCellPop() {
    return state == popN;
  }

  bool isCellPadding() {
    return col == 0 || col == boardWidth + 1 || row == 0 || row == boardHeight + 1;
  }

  String getCellPic() {
    return "assets/player${player + 1}_$state.png";
  }
}