import 'package:flutter/material.dart';
import 'package:net/pages/home.dart';
import 'package:net/user/mongodb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  runApp(const ShelterNet());
}

class ShelterNet extends StatelessWidget {
  const ShelterNet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShelterNet',
      home: HomePage(),
    );
  }
}
