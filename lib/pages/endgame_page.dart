import 'package:chain_reaction/models/player.dart';
import 'package:flutter/material.dart';

class EndGamePage extends StatefulWidget {
  final Player winner;
  const EndGamePage({required this.winner,super.key});

  @override
  State<EndGamePage> createState() => _EndGamePageState();
}

class _EndGamePageState extends State<EndGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(
          "GameOver player ${widget.winner.index + 1} Won",
          style: const TextStyle(fontSize: 40),
        ),
      )),
    );
  }
}
