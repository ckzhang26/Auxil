import 'package:net/config/imported.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ShelterNet());
}

class ShelterNet extends StatelessWidget {
  const ShelterNet({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShelterNet',
      home: LoginPage(),
    );
  }
}
