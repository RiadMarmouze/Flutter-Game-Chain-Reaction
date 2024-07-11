import 'package:chain_reaction/helpers/helper_function.dart';
import 'package:flutter/material.dart';

class StartGamePage extends StatefulWidget {
  const StartGamePage({Key? key}) : super(key: key);

  @override
  State<StartGamePage> createState() => _StartGamePageState();
}

class _StartGamePageState extends State<StartGamePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isJoinedToRoom = false;

  @override
  void initState() {
    super.initState();
    getUserJoinedStatus();
  }

  void getUserJoinedStatus() async {
    final value = await HelperFunctions.getUserJoinedStatus();
    if (value != null) {
      setState(() {
        _isJoinedToRoom = value;
      });
      if (_isJoinedToRoom) {
        navigateToOnlineGame(false);
      }
    }
  }

  void navigateToOnlineGame(bool isCreator) {
    Navigator.of(_scaffoldKey.currentContext!).pushReplacementNamed('/onlinegame', arguments: isCreator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/localgame');
                },
                child: const Text("Start Local Game"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onlinegame', arguments: true);
                },
                child: const Text("Create Room"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/joingame');
                },
                child: const Text("Join Room"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
