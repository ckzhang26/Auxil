import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/mongodb.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
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
          ],
        ),
      ),
    );
  }

  Future<void> submitButton(BuildContext context) async {
    var udata = await MongoDB.user.username;
    var edata = await MongoDB.user.email;
    if (udata == usernameController.text && edata == emailController.text) {
      showPasswordDialog(context);
    }
  }

  void showPasswordDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update Password"),
            content: Gui.passwordInput("New Password", newPasswordController),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              ElevatedButton(onPressed: () {}, child: const Text("Update"))
            ],
          );
        });
  }
}
