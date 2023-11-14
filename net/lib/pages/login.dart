import 'package:net/config/imported.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Need controllers for text input
  final usernameController = TextEditingController();
  final passowrdController = TextEditingController();

  // Setup main formatting
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.yellow,
      appBar: Gui.header("ShelterNet"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Insert all interactables into the main widget column,
          children: <Widget>[
            // Gui helpers
            Gui.pad(28),
            Gui.textInput("Username", usernameController),
            Gui.pad(5),
            Gui.textInput("Password", passowrdController),
            Gui.labelButton("Forgot Password?", 26),
            Gui.pad(64),
            Gui.button("Login"),
            Gui.pad(18),
            Gui.label("Or", 23),
            Gui.pad(18),
            Gui.button("Continue As Guest"),
            Gui.pad(22),
            Gui.labelButton("Sign Up", 28),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passowrdController.dispose();
    super.dispose();
  }
}
