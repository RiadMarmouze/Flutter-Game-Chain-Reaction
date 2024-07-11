import 'package:chain_reaction/models/player.dart';
import 'package:chain_reaction/pages/joingame_page.dart';
import 'package:chain_reaction/pages/online_game_page.dart';
import 'package:chain_reaction/pages/welcome_page.dart';
import 'package:chain_reaction/providers/online_game_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chain_reaction/providers/local_game_state_provider.dart';

import 'package:chain_reaction/pages/startgame_page.dart';
import 'package:chain_reaction/pages/local_game_page.dart';
import 'package:chain_reaction/pages/endgame_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Create a method to initialize Firebase
  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase and wait for it to complete
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        // Check the connection state of the Future
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, return your app
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => LocalGameStateProvider()),
              ChangeNotifierProvider(create: (context) => OnlineGameStateProvider()),
            ],
            child: MaterialApp(
              routes: {
                '/': (context) => const WelcomePage(),
                '/login': (context) => const LoginPage(),
                '/register': (context) => const RegisterPage(),
                '/startgame': (context) => const StartGamePage(),
                '/localgame': (context) => const LocalGamePage(),
                '/onlinegame': (context) {
                  final args = ModalRoute.of(context)!.settings.arguments as bool; // Extract the passed argument
                  return OnlineGamePage(createRoom: args);
                },
                '/joingame': (context) => const JoinGamePage(),
                '/endgame': (context) {
                  final args = ModalRoute.of(context)!.settings.arguments as Player; // Extract the passed argument
                  return EndGamePage(winner: args);
                },
              },
              debugShowCheckedModeBanner: false,
            ),
          );
        } else {
          // If the Future is not complete,
          // show a loading indicator
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(), // Loading indicator
              ),
            ),
          );
        }
      },
    );
  }
}
