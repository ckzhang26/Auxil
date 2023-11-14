import 'package:net/config/imported.dart';

class VeterinaryPage extends StatefulWidget {
  const VeterinaryPage({super.key});

  @override
  State<VeterinaryPage> createState() => VeterinaryPageState();
}

class VeterinaryPageState extends State<VeterinaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Veterinary"),
    );
  }
}
