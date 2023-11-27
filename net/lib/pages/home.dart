import 'package:flutter/material.dart';

import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'resources/shelters.dart';
import 'resources/job_search.dart';
import 'resources/map_view.dart';
import 'resources/veterinary.dart';
import 'resources/healthcare.dart';

class HomePage extends StatefulWidget {
  final String zipCode;

  HomePage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      bool? initLoad = prefs.getBool('has_access');
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Config.yellow,
        appBar: Gui.header("Welcome", true),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Gui.labelButton(
                  "Logout", 28, () => {checkPrefs(context, true)}),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Gui.iconLabelButton("Shelters", const Icon(Icons.night_shelter),
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SheltersPage(
                              zipCode: widget.zipCode,
                            )),
                  );
                }),
                Gui.iconLabelButton("Job Search", const Icon(Icons.work), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JobsPage()),
                  );
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Gui.iconLabelButton(
                    "Healthcare", const Icon(Icons.medical_services), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HealthCarePage()),
                  );
                }),
                Gui.iconLabelButton("Veterinary", const Icon(Icons.pets), () {
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
                Gui.iconLabelButton("Map View", const Icon(Icons.location_on),
                    () {
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
        )));
  }
}
