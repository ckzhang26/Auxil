import 'package:flutter/material.dart';
import 'package:net/pages/home.dart';
import 'package:net/user/mongodb.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  print("jump");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ZipCode()),
    ChangeNotifierProvider(create: (context) => GoogleMapsMarkerList())
  ], child: const ShelterNet()));
}

class ZipCode extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  void updateValue(String newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class GoogleMapsMarkerList extends ChangeNotifier {
  List<Marker> _list = [];

  List<Marker> get list => _list;

  void addValue(Marker newValue) {
    _list.add(newValue);
    notifyListeners();
  }

  void clear() {
    _list.clear();
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
