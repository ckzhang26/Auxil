// ignore_for_file: use_build_context_synchronously

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/main.dart';
import 'package:net/pages/resources/card_item.dart';
import 'package:net/user/mongodb.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../config/maps.dart' as maps;
import 'map_view.dart';

class SheltersPage extends StatefulWidget {
  final String zipCode;

  const SheltersPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<SheltersPage> createState() => _SheltersPageState();
}

class _SheltersPageState extends State<SheltersPage> {
  var shelterData;
  var housingData;

  Future<void> _fetchData() async {
    String city = await maps.getCityNameFromZip2(widget.zipCode);
    print(city);
    if (city != null) {
      try {
        final shelterResponse = await http.get(Uri.parse(
            'https://data.orghunter.com/v1/charitysearch?user_key=ada9f57c9b97ab634db6635fd3004f72&searchTerm=shelter&city=$city'));

        final housingResponse = await http.get(Uri.parse(
            'https://data.orghunter.com/v1/charitysearch?user_key=ada9f57c9b97ab634db6635fd3004f72&city=$city&category=L'));

        if (shelterResponse.statusCode == 200 &&
            housingResponse.statusCode == 200) {
          shelterData = jsonDecode(shelterResponse.body);
          housingData = jsonDecode(housingResponse.body);

          // Update pins
          Provider.of<GoogleMapsMarkerList>(context, listen: false).clear();
          for (var result in shelterData['data']) {
            Marker marker = Marker(
                markerId: MarkerId(result['charityName']),
                position: LatLng(double.parse(result['latitude']),
                    double.parse(result['longitude'])));
            Provider.of<GoogleMapsMarkerList>(context, listen: false)
                .addValue(marker);
          }
          for (var result in housingData['data']) {
            Marker marker = Marker(
                markerId: MarkerId(result['charityName']),
                position: LatLng(double.parse(result['latitude']),
                    double.parse(result['longitude'])));
            Provider.of<GoogleMapsMarkerList>(context, listen: false)
                .addValue(marker);
          }

          setState(() {});
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return (shelterData == null || housingData == null)
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: Gui.headerWelcome("Shelters", false, context,
                const Icon(Icons.my_location), mapView),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: shelterData['data'].length +
                            housingData['data'].length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < shelterData['data'].length) {
                            var result = shelterData['data'][index];
                            return CardItem(
                                resultType: "shelter",
                                charityName: result['charityName'],
                                url: result['url'],
                                zipCode: result['zipCode']);
                          } else {
                            var result = housingData['data']
                                [index - shelterData['data'].length];
                            return CardItem(
                                resultType: "shelter",
                                charityName: result['charityName'],
                                url: result['url'],
                                zipCode: result['zipCode']);
                          }
                        }))
              ],
            ),
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
