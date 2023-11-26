import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:net/config/imported.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      future: getLocationFromZip(widget.zipCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: snapshot.requireData,
              zoom: 14.0,
            ),
          );
        }
      },
    );
  }

  Future<LatLng> getLocationFromZip(String zipCode) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$zipCode&key=AIzaSyC1RuhYlMwVwWMn6RZwjBuzvECC298vpgM'));
    final responseBody = json.decode(response.body);
    return LatLng(responseBody['results'][0]['geometry']['location']['lat'],
        responseBody['results'][0]['geometry']['location']['lng']);
  }
}
