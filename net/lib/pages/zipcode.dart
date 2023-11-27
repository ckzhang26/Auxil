import 'package:flutter/material.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
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
      appBar: Gui.header("Zip Code", true),
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
            Gui.textInput("Zip Code", zipCodeController),
            Gui.pad(50),
            Gui.button(
                "Submit",
                () => {
                      Provider.of<ZipCode>(context, listen: false)
                          .updateValue(zipCodeController.text),
                      Navigator.of(context).popUntil((route) => route.isFirst),
                    }),
            Gui.pad(18),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    zipCodeController.dispose();
    super.dispose();
  }
}
