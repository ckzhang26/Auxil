// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/mongodb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:net/config/cfg.dart';
import 'package:net/pages/login.dart';
import 'package:provider/provider.dart';
import 'package:net/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isEditing = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  void _validateAccess(BuildContext context, bool logout) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await MongoDB.syncLocalUser(true);

    if (logout) {
      MongoDB.user.guest = true;
      prefs.clear();
      prefs.setBool(Config.initAccessPos, true);
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ));
    } else {
      bool? initLoad = prefs.getBool(Config.initAccessPos);
      if (initLoad != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ));
      } else {
        Provider.of<ZipCode>(context, listen: false)
            .updateValue(MongoDB.user.zip);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _validateAccess(context, false);
    print(MongoDB.user.guest);
    return Scaffold(
      appBar: Gui.header("Settings", false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: MongoDB.user.guest == false
                ? [
                    buildUserInfoLabel("Username", MongoDB.user.username ?? "",
                        usernameController),
                    buildUserInfoLabel(
                        "Email", MongoDB.user.email ?? "", emailController),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: isEditing
                          ? ElevatedButton(
                              onPressed: () {
                                saveChanges(context);
                              },
                              child: const Text('Save Changes'))
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              child: const Text('Edit')),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Gui.labelButton(
                          "Logout", 24, () => {_validateAccess(context, true)}),
                    ),
                  ]
                : [
                    Center(
                        child: Gui.label("You are logged in as a guest", 27)),
                    Center(
                        child: Gui.label(
                            "Please login before trying to access settings",
                            16))
                  ],
          ),
        ),
      ),
    );
  }

  Future<void> saveChanges(BuildContext context) async {
    setState(() {
      isEditing = false;
    });

    bool success = await MongoDB.updateUserToDatabase(
        MongoDB.user.username,
        UserModel(
            guest: false,
            email: emailController.text,
            username: usernameController.text,
            password: MongoDB.user.password,
            zip: MongoDB.user.zip,
            shelter: [],
            job: [],
            healthcare: [],
            veterinary: []));

    Gui.notify(context, success ? "Successfully updated" : "Failed to update!");
  }

  Widget buildUserInfoLabel(
    String label,
    String value,
    TextEditingController controller,
  ) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  width: 5,
                ),
                isEditing
                    ? TextFormField(
                        controller: controller,
                        decoration:
                            InputDecoration(hintText: 'Enter your $label'),
                      )
                    : Text(
                        value,
                        style: const TextStyle(fontSize: 16),
                      )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
