import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:provider/provider.dart';

import '../../config/maps.dart' as maps;
import '../../main.dart';

class MapPage extends StatefulWidget {
  final String zipCode;

  const MapPage({Key? key, required this.zipCode}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: maps.getLatLngFromZip(widget.zipCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
              appBar: Gui.header("Map", false),
              body: Center(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: snapshot.requireData,
                    zoom: 14.0,
                  ),
                  markers:
                      Provider.of<GoogleMapsMarkerList>(context, listen: false)
                          .list
                          .toSet(),
                ),
              ));
        }
      },
    );
  }
}
