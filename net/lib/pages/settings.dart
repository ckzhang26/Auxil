// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/password_reset.dart';
import 'package:net/user/mongodb.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isEditing = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  late String originalUsername;
  late String originalEmail;

  @override
  void initState() {
    super.initState();
    originalUsername = MongoDB.user.username;
    originalEmail = MongoDB.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Settings", false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: MongoDB.user.guest == false
                ? [
                    buildUserInfoLabel(
                        "Username", MongoDB.user.username, usernameController),
                    buildUserInfoLabel(
                        "Email", MongoDB.user.email, emailController),
                    const SizedBox(
                      height: 16,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: isEditing
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    cancelChanges(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      saveChanges(context);
                                    },
                                    child: const Text('Save Changes')),
                              ],
                            )
                          : Row(children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PasswordPage()));
                                  },
                                  child: const Text('Change Password?')),
                              Gui.pad(20),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  },
                                  child: const Text('Edit')),
                            ]),
                    ),
                    Gui.pad(25),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:
                          Gui.button("Logout", () => {MongoDB.logout(context)}),
                    ),
                  ]
                : [
                    Center(
                        child: Gui.label("You are logged in as a guest", 27)),
                    Center(
                        child: Gui.label(
                            "Please login before trying to access settings",
                            16)),
                    Gui.pad(25),
                    Align(
                      alignment: Alignment.bottomRight,
                      child:
                          Gui.button("Logout", () => {MongoDB.logout(context)}),
                    ),
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

    UserModel updatedUser = UserModel(
        guest: false,
        email: emailController.text,
        username: usernameController.text,
        password: MongoDB.user.password,
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

    Gui.notify(context, success ? "Successfully updated" : "Failed to update!");
  }

  Future<void> cancelChanges(BuildContext context) async {
    setState(() {
      isEditing = false;
      usernameController.text = originalUsername;
      emailController.text = originalEmail;
    });
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

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
