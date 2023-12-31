import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:net/config/gui.dart';
import 'package:http/http.dart' as http;
import 'package:net/pages/resources/card_item.dart';
import 'package:net/user/mongodb.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../pages/resources/map_view.dart';
import '../../config/maps.dart' as maps;
import '../../main.dart';

class HealthCarePage extends StatefulWidget {
  final String zipCode;

  const HealthCarePage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<HealthCarePage> createState() => HealthCarePageState();
}

class HealthCarePageState extends State<HealthCarePage> {
  var hospitalData;

  Future<void> _fetchData() async {
    final body = {
      "conditions": [
        {
          "resource": "t",
          "property": "citytown",
          "value": await maps.getCityNameFromZip2(MongoDB.user.zip),
          "operator": "="
        }
      ],
      "limit": 10
    };
    final jsonString = json.encode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    final response = await http.post(
        Uri.parse(
            'https://data.cms.gov/provider-data/api/1/datastore/query/xubh-q36u/0'),
        headers: headers,
        body: jsonString);
    if (response.statusCode == 200) {
      hospitalData = jsonDecode(response.body)['results'];

      Provider.of<GoogleMapsMarkerList>(navigationkey.currentContext!,
              listen: false)
          .clear();
      for (var result in hospitalData) {
        String addressQuery =
            "${result['address']}%20${result['citytown']}%20${result['state']}";
        var path =
            'https://maps.googleapis.com/maps/api/geocode/json?address=$addressQuery&key=AIzaSyC1RuhYlMwVwWMn6RZwjBuzvECC298vpgM';

        LatLng coords = await maps.getLatLngFromAddress(addressQuery);
        Marker marker = Marker(
          markerId: MarkerId(result['facility_name']),
          position: coords,
          infoWindow: InfoWindow(title: result['facility_name']),
        );
        Provider.of<GoogleMapsMarkerList>(navigationkey.currentContext!,
                listen: false)
            .addValue(marker);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return (hospitalData == null)
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: Gui.headerWelcome("Healthcare", false, context,
                const Icon(Icons.my_location), mapView),
            body: ListView.builder(
                itemCount: hospitalData.length,
                itemBuilder: (BuildContext context, int index) {
                  var result = hospitalData[index];
                  return CardItem(
                    resultType: "healthcare",
                    facilityName: result['facility_name'],
                    address: result['address'],
                    cityTown: result['citytown'],
                    state: result['zip_code'],
                    telephoneNumber: result['telephone_number'],
                  );
                }),
          );
  }

  void mapView() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapPage(
                zipCode: MongoDB.user.zip,
              )),
    );
  }
}
