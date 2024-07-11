import 'package:flutter/material.dart';

class Player {
  static const List<Color> playerColor = [
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.blue,
  ];

  late String id;
  late Color color;
  String username;
  int index;

  Player({required this.index, required this.username}) {
    color = index != -1 ? playerColor[index] : Colors.transparent;
  }

  Player.withId({required this.id, required this.index, required this.username}) {
    color = index != -1 ? playerColor[index] : Colors.transparent;
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'username': username,
      'index': index,
    };
  }

  static Player fromMap(Map<String, dynamic> map) {
    return Player.withId(
      id: map['id'],
      username: map['username'],
      index: map['index'],
    );
  }
}
