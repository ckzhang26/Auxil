import 'package:net/config/imported.dart';

import 'resources/shelters.dart';
import 'resources/job_search.dart';
import 'resources/map_view.dart';
import 'resources/veterinary.dart';
import 'resources/healthcare.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
                Gui.iconButton(
                  "Shelters",
                  Icon(Icons.night_shelter, size: 100.0),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SheltersPage()),
                    );
                  },
                ),
                Gui.iconButton(
                  "Job Search",
                  Icon(Icons.work, size: 100.0),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JobsPage()),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Gui.iconButton(
                  "Healthcare",
                  Icon(Icons.medical_services, size: 100.0),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HealthCarePage()),
                    );
                  },
                ),
                Gui.iconButton(
                  "Veterinary",
                  Icon(Icons.pets, size: 100.0),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VeterinaryPage()),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Gui.iconButton(
                  "Map View",
                  Icon(Icons.location_on, size: 100.0),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        )));
  }
}
