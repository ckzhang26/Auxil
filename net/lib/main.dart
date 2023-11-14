import 'package:net/config/imported.dart';

void main() {
  runApp(const ShelterNet());
}

class ShelterNet extends StatelessWidget {
  const ShelterNet({super.key});

  // root
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShelterNet',
      home: LoginPage(), // init page
    );
  }
}