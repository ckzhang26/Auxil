import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String username = "JakeFromStateFarm";
  String email = "jake@fromStateFarm.com";
  String password = '*********';
  bool isEditing = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = username;
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Settings", false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildUserInfoLabel("Username", username, usernameController),
              buildUserInfoLabel("Password", password, passwordController),
              buildUserInfoLabel("email", email, emailController),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: isEditing
                    ? ElevatedButton(
                        onPressed: () {
                          saveChanges();
                        },
                        child: const Text('Save Changes'))
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: const Text('Edit')),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveChanges() {
    String newUsername = usernameController.text;
    String newPassword = passwordController.text;
    String newEmail = emailController.text;
    print('Saved changes: Username: $newUsername, Email: $newEmail');

    setState(() {
      isEditing = false;
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
}
