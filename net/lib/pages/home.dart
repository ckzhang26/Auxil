import 'package:flutter/material.dart';

import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/login.dart';
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

  void checkPrefs(BuildContext context, bool logout) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (logout) {
      prefs.clear();
      prefs.setBool("has_access", false);
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ));
    } else {
      bool? initLoad = prefs.getBool(Config.initPos);
      if (initLoad != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkPrefs(context, false);
    widget.zipCode = Provider.of<ZipCode>(context).value;
    print(widget.zipCode);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Config.yellow,
        appBar: Gui.header("Welcome", true),
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
                        "Logout", 24, () => {checkPrefs(context, true)}),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.zipCode,
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          child: Text('Change Zip Code'),
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
                                        height: 200,
                                        color: Config.green,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
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
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          Config.yellow)),
                                              child: const Text('Submit'),
                                              onPressed: () => {
                                                Navigator.pop(context),
                                                Provider.of<ZipCode>(context,
                                                        listen: false)
                                                    .updateValue(
                                                        zipCodeController.text)
                                              },
                                            ),
                                          ],
                                        ))),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
}
