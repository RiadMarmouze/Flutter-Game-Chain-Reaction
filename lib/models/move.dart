class Move {
  int row;
  int col;
  int playerindex;

  Move({required this.row, required this.col, required this.playerindex});

  // Method to convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'row': row,
      'col': col,
      'playerindex': playerindex,
    };
  }

  // Method to create a User object from a Map
  static Move fromMap(Map<String, dynamic> map) {
    return Move(
      row: map['row'],
      col: map['col'],
      playerindex: map['playerindex'],
    );
  }
}