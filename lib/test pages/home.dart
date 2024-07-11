import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<User?> _userSubscription;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;

    // Detect when a user signs in or out
    _userSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        if (user != null) {
          setState(() {
            _user = FirebaseAuth.instance.currentUser!;
          });
        } else {
          setState(() {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (_) => false,
              );
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _user.displayName != null
            ? Text('Welcome ${_user.displayName}')
            : const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "User Info",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "Email: ${_user.email}\n"
              "Id: ${_user.uid}\n"
              "DisplayName: ${_user.displayName}",
            ),
            TextButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed('/profile');
                if (!mounted) {
                  return;
                }
                if (FirebaseAuth.instance.currentUser != null) {
                  // Refresh the UI with a new user instance
                  // to catch any changes done in the profile screen
                  setState(() {
                    _user = FirebaseAuth.instance.currentUser!;
                  });
                }
              },
              child: const Text('Proflie Screen'),
            )
          ],
        ),
      ),
    );
  }
}