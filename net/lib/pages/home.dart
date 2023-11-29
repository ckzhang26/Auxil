// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/login.dart';
import 'package:net/user/mongodb.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'resources/shelters.dart';
import 'resources/job_search.dart';
import 'resources/map_view.dart';
import 'resources/veterinary.dart';
import 'resources/healthcare.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  String zipCode;

  HomePage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController zipCodeController = TextEditingController();

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

    widget.zipCode = Provider.of<ZipCode>(context).value;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Config.yellow,
        appBar: Gui.headerWelcome("Welcome", true, context),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Gui.labelButton(
                        "Logout", 24, () => {_validateAccess(context, true)}),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.zipCode == "null" ? "" : widget.zipCode,
                          style: const TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          child: const Text('Change Zip Code'),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Container(
                                      height: 300,
                                      padding: const EdgeInsets.all(12.0),
                                      color: Config.green,
                                      child: ListView(
                                        children: <Widget>[
                                          const Text(
                                            'Change Zip Code',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          Gui.textInput(
                                              "Zip Code", zipCodeController),
                                          ElevatedButton(
                                            style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Config.yellow)),
                                            child: const Text('Submit'),
                                            onPressed: () =>
                                                {zipCodeButton(context)},
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Gui.iconLabelButton(
                            "Shelters", const Icon(Icons.night_shelter), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SheltersPage(
                                      zipCode: widget.zipCode,
                                    )),
                          );
                        }),
                        Gui.iconLabelButton(
                            "Job Search", const Icon(Icons.work), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JobsPage()),
                          );
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Gui.iconLabelButton(
                            "Healthcare", const Icon(Icons.medical_services),
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthCarePage(
                                      zipCode: widget.zipCode,
                                    )),
                          );
                        }),
                        Gui.iconLabelButton(
                            "Veterinary", const Icon(Icons.pets), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VeterinaryPage()),
                          );
                        }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Gui.iconLabelButton(
                            "Map View", const Icon(Icons.location_on), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MapPage(
                                      zipCode: widget.zipCode,
                                    )),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  void zipCodeButton(BuildContext context) async {
    String zipCodeInput = zipCodeController.text;
    RegExp zipCodeRegExp = RegExp(r'^\d{5}$');
    if (!zipCodeRegExp.hasMatch(zipCodeInput)) {
      Gui.notify(context, "Please enter a valid zip code");
      return;
    }

    Provider.of<ZipCode>(context, listen: false).updateValue(zipCodeInput);

    if (!MongoDB.user.guest) {
      MongoDB.user.zip = zipCodeInput;
      bool success = await MongoDB.updateUserToDatabase(
          MongoDB.user.username, MongoDB.user);
      if (!success) {
        Gui.notify(context, "Error syncing zipcode to account");
      }
      MongoDB.saveLocalUser();
    } else {
      MongoDB.storeLocalUser(UserModel.getGuest(zipCodeInput));
    }

    Navigator.of(context).popUntil((route) => route.isFirst);

    setState(() {});
  }

  @override
  void dispose() {
    zipCodeController.dispose();
    super.dispose();
  }
}
