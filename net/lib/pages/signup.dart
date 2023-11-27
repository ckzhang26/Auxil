import 'package:flutter/material.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/mongodb.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.yellow,
      appBar: Gui.header("Sign Up"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Insert all interactables into the main widget column,
          children: <Widget>[
            // Gui helpers
            Gui.button(
                "Sign up",
                () => {
                      MongoDB.signup(
                        Database(
                            email: "email",
                            username: "username",
                            password: "password",
                            zip: "zip",
                            bookmarks: Bookmarks(
                                shelther: ["1"],
                                job: ["2"],
                                healthcare: ["3"],
                                veterinary: ["4"]))),
                    }),
          ],
        ),
      ),
    );
  }
}
