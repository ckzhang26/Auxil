import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/main.dart';
import 'package:net/user/mongodb.dart';
import 'package:crypto/crypto.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Reset Password", false),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .05,
            vertical: MediaQuery.of(context).size.height * .001),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Gui.pad(25),
            Gui.textInput("Username", usernameController),
            Gui.pad(5),
            Gui.textInput("Email", emailController),
            Gui.pad(5),
            Gui.button("Submit", () => submitButton(context))
          ],
        ),
      ),
    );
  }

  Future<void> submitButton(BuildContext context) async {
    newPasswordController.clear();
    confirmPasswordController.clear();
    var udata = await MongoDB.user.username;
    var edata = await MongoDB.user.email;
    if (udata == usernameController.text && edata == emailController.text) {
      showPasswordDialog(context);
    } else {
      Gui.notify(context, "Either Username or Email was Incorrect");
    }
  }

  void showPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update Password"),
            content: SingleChildScrollView(
              child: Column(children: [
                Gui.passwordInput("New Password", newPasswordController),
                Gui.passwordInput("Confirm Password", confirmPasswordController)
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (newPasswordController.text.length < 8) {
                      Gui.notify(context,
                          "Password must be at least 8 characters long");
                    } else if (newPasswordController.text !=
                        confirmPasswordController.text) {
                      Gui.notify(
                          context, "Passwords do not match, please try again");
                    } else {
                      updatePassword();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  Future<void> updatePassword() async {
    var encrypted =
        sha256.convert(utf8.encode(newPasswordController.text)).toString();
    UserModel updatedUser = UserModel(
        guest: false,
        email: MongoDB.user.email,
        username: MongoDB.user.username,
        password: encrypted,
        zip: MongoDB.user.zip,
        shelter: [],
        job: [],
        healthcare: [],
        veterinary: []);

    bool success =
        await MongoDB.updateUserToDatabase(MongoDB.user.username, updatedUser);
    if (success) {
      MongoDB.setUser(updatedUser);
      setState(() {});
    }

    Gui.notify(navigationkey.currentContext!,
        success ? "Successfully updated" : "Failed to update!");
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }
}
