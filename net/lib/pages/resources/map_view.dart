import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:net/config/imported.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../config/maps.dart' as maps;

class MapPage extends StatefulWidget {
  final String zipCode;

  const MapPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: maps.getLocationFromZip(widget.zipCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
              appBar: Gui.header("Map"),
              body: Center(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: snapshot.requireData,
                    zoom: 14.0,
                  ),
                ),
              ));
        }
      },
    );
  }
}
