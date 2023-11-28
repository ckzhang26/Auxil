import 'package:flutter/material.dart';
import 'package:net/pages/home.dart';
import 'package:net/user/mongodb.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  runApp(ChangeNotifierProvider(
      create: (context) => ZipCode(), child: const ShelterNet()));
}

class ZipCode extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  void updateValue(String newValue) {
    _value = newValue;
    notifyListeners();
  }
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
