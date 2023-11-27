import 'package:flutter/material.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/home.dart';
import 'package:net/pages/password_reset.dart';
import 'package:net/pages/signup.dart';
import 'package:net/pages/zipcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Need controllers for text input
  final usernameController = TextEditingController();
  final passowrdController = TextEditingController();

  Future<void> clearPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Setup main formatting
  @override
  Widget build(BuildContext context) {
    clearPrefs();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.yellow,
      appBar: Gui.header("Shelter", true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Insert all interactables into the main widget column,
          children: <Widget>[
            // Gui helpers
            Gui.pad(25),
            Gui.textInput("Username", usernameController),
            Gui.pad(5),
            Gui.passwordInput("Password", passowrdController),
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
            Gui.button("Login", () => { loginButton(context), Navigator.of(context).popUntil((route) => route.isFirst) }),
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
    );
  }

  Future<void> guestButton(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('has_access', true);

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ZipCodePage()),
    );
  }

  Future<void> loginButton(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('has_access', true);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passowrdController.dispose();
    super.dispose();
  }
}
