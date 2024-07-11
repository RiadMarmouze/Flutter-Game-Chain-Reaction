import 'package:chain_reaction/widgets/widgets.dart';
import 'package:flutter/material.dart';


class JoinGamePage extends StatefulWidget {
  const JoinGamePage({super.key});

  @override
  State<JoinGamePage> createState() => _JoinGamePageState();
}

class _JoinGamePageState extends State<JoinGamePage> {
  String roomId = "";
  final bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor
              ),
            )
          : SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Join Room",
                    style: TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter Room ID",
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w400
                    )
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: textInputDecoration.copyWith(
                        labelText: "Room ID",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).primaryColor,
                        )),
                    validator: (val) {
                      if (val!.length < 6) {
                        return "Room ID must be at least 6 characters";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        roomId = val;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(_scaffoldKey.currentContext!).pushReplacementNamed('/onlineGame', arguments: false);
                    },
                    child: const Text("Join Room"),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}