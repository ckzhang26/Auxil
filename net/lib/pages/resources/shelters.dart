import 'package:net/config/imported.dart';

class SheltersPage extends StatefulWidget {
  const SheltersPage({super.key});

  @override
  State<SheltersPage> createState() => SheltersPagetate();
}

class SheltersPagetate extends State<SheltersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Shelters"),
    );
  }
}