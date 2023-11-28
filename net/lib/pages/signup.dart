import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
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
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();
  final zipcodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.yellow,
      appBar: Gui.header("Sign Up Form", false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Insert all interactables into the main widget column,
          children: <Widget>[
            // Gui helpers
            Gui.pad(25),
            Gui.textInput("Email", emailController),
            Gui.pad(5),
            Gui.textInput("Username", usernameController),
            Gui.pad(5),
            Gui.passwordInput("Password", passwordController),
            Gui.pad(5),
            Gui.passwordInput("Confirm Password", cpasswordController),
            Gui.pad(15),
            Gui.textInput("Zip Code", zipcodeController),
            Gui.pad(5),
            Gui.button("Sign up", () => {signUpButton(context)}),
          ],
        ),
      ),
    );
  }

  bool validEmail(String email) {
    // thx stack overflow
    return !RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Future<void> signUpButton(context) async {
    String email = emailController.text;
    if (validEmail(email)) {
      Gui.notify(context, "Please use a valid Email");
      return;
    }

    String username = usernameController.text;
    if (username.length < 3) {
      Gui.notify(context, "Your username must be atleast 3 characters long");
      return;
    }

    var udata = await MongoDB.getUser(username);
    if (udata != null) {
      if (udata["username"] == "no") {
        Gui.notify(context, "Connection failure");
      } else {
        Gui.notify(context, "Invalid login attempt");
      }
      return;
    }
  
    String password1 = passwordController.text;
    if (password1.length < 8) {
      Gui.notify(context, "Your password must be atleast 8 characters long");
      return;
    }

    String password2 = cpasswordController.text;
    if (password1 != password2) {
      Gui.notify(context, "Passwords do not match");
      return;
    }

    var zip = zipcodeController.text;
    if (zip.length != 5) {
      Gui.notify(context, "Please enter a valid Zip Code");
      return;
    }

    var encrpted = sha256.convert(utf8.encode(password2)).toString();
    Bookmarks bookmarks = Bookmarks(// empty
        shelter: [], job: [], healthcare: [], veterinary: []);

    Database user = Database(
        isGuest: false,
        email: email,
        username: username,
        password: encrpted,
        zip: zip,
        bookmarks: bookmarks);

    if (await MongoDB.signup(context, user)) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
    zipcodeController.dispose();
    super.dispose();
  }
}
