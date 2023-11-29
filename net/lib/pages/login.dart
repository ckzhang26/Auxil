// ignore_for_file: use_build_context_synchronously, duplicate_ignore, use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/password_reset.dart';
import 'package:net/pages/signup.dart';
import 'package:net/pages/zipcode.dart';
import 'package:net/user/mongodb.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Need controllers for text input
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Setup main formatting
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Config.yellow,
        appBar: Gui.header("Shelter", true),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .05,
              vertical: MediaQuery.of(context).size.height * .001),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // Insert all interactables into the main widget column,
            children: <Widget>[
              // Gui helpers
              Gui.pad(25),
              Gui.textInput("Username", usernameController),
              Gui.pad(5),
              Gui.passwordInput("Password", passwordController),
              Gui.labelButton(
                  "Forgot Password?",
                  26,
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PasswordPage()),
                        )
                      }),
              Gui.pad(64),
              Gui.button("Login", () => {loginButton(context)}),
              Gui.pad(18),
              Gui.label("Or", 23),
              Gui.pad(18),
              Gui.button("Continue As Guest", () => {guestButton(context)}),
              Gui.pad(22),
              Gui.labelButton(
                  "Sign Up",
                  28,
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        )
                      }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> guestButton(BuildContext context) async {
    MongoDB.giveAccess(context);
    await MongoDB.storeLocalUser(Database.getEmpty());
    MongoDB.syncLocalUser(false); 

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ZipCodePage()),
    );
  }

  Future<void> loginButton(BuildContext context) async {
    String username = usernameController.text;
    if (username.length < 3) {
      Gui.notify(context, "Usernames are atleast 3 characters long");
      return;
    }

    String password = passwordController.text;
    if (password.length < 8) {
      Gui.notify(context, "Passwords are atleast 8 characters long");
      return;
    }

    var udata = await MongoDB.getUser(username);
    if (udata == null) {
      Gui.notify(context, "Invalid login attempt");
      return;
    }

    var passEncrypted = sha256.convert(utf8.encode(password)).toString();
    if (passEncrypted != udata["password"]) {
      Gui.notify(context, "Password is incorrect");
      return;
    }

    MongoDB.giveAccess(context);
    await MongoDB.storeLocalUser(Database(
        isGuest: false,
        email: udata["email"].toString(),
        username: udata["username"].toString(),
        password: udata["password"].toString(),
        zip: udata["zip"].toString(),
        bookmarks: Bookmarks(
          shelter: udata["bookmarks"]["shelter"],
          job: udata["bookmarks"]["job"],
          healthcare: udata["bookmarks"]["healthcare"],
          veterinary: udata["bookmarks"]["veterinary"],
        )));
    MongoDB.syncLocalUser(false); 

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
