import 'package:net/config/imported.dart';
import 'package:net/pages/zipcode.dart';

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
      appBar: Gui.header("Shelter"),
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
            Gui.textInput("Password", passowrdController),
            Gui.labelButton("Forgot Password?", 26),
            Gui.pad(64),
            Gui.button(
                "Login",
                () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ZipCodePage()),
                      )
                    }),
            Gui.pad(18),
            Gui.label("Or", 23),
            Gui.pad(18),
            Gui.button(
                "Continue As Guest",
                () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ZipCodePage()),
                      )
                    }),
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
