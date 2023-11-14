import 'package:net/config/imported.dart';

class HealthCarePage extends StatefulWidget {
  const HealthCarePage({super.key});

  @override
  State<HealthCarePage> createState() => HealthCarePageState();
}

class HealthCarePageState extends State<HealthCarePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Healthcare"),
    );
  }
}