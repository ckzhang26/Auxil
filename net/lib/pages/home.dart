import 'package:net/config/imported.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Config.yellow,
        appBar: Gui.header("Welcome"),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
