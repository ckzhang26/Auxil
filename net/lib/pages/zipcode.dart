import 'package:flutter/material.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/mongodb.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class ZipCodePage extends StatefulWidget {
  const ZipCodePage({super.key});

  @override
  State<ZipCodePage> createState() => _ZipCodePageState();
}

class _ZipCodePageState extends State<ZipCodePage> {
  final TextEditingController zipCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.yellow,
      appBar: Gui.header("Zip Code", false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Insert all interactables into the main widget column,
          children: <Widget>[
            // Gui helpers
            Gui.pad(25),
            const Text(
              "Provide a zip code to find services in the area:",
              style: TextStyle(fontSize: 42.0),
              textAlign: TextAlign.center,
            ),
            Gui.pad(50),
            Gui.textInputNK("Zip Code", zipCodeController),
            Gui.pad(50),

            Gui.button("Submit", () => {zipCodeButton(context)}),
            Gui.pad(18),
          ],
        ),
      ),
    );
  }

  Future<void> zipCodeButton(BuildContext context) async {
    String zipCodeInput = zipCodeController.text;
    RegExp zipCodeRegExp = RegExp(r'^\d{5}$');
    if (!zipCodeRegExp.hasMatch(zipCodeInput)) {
      Gui.notify(context, "Please enter a valid zip code");
      return;
    }
    Provider.of<ZipCode>(context, listen: false)
        .updateValue(zipCodeController.text);
    MongoDB.giveAccess(context);
    Provider.of<GoogleMapsMarkerList>(context, listen: false).clear();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  void dispose() {
    zipCodeController.dispose();
    super.dispose();
  }
}
