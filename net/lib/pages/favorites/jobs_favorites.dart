
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/main.dart';
import 'package:net/pages/resources/card_item.dart';
import 'package:net/user/mongodb.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../config/maps.dart' as maps;
import '../resources/map_view.dart';

class JobsFavoritesPage extends StatefulWidget {
  final String zipCode;

  const JobsFavoritesPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<JobsFavoritesPage> createState() => _JobsFavoritesPageState();
}

class _JobsFavoritesPageState extends State<JobsFavoritesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: Gui.headerWelcome("Job Favorites", false, context,
                const Icon(Icons.my_location), mapView),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: MongoDB.user.job.length,
                        itemBuilder: (BuildContext context, int index) {
                          var result = json.decode(MongoDB.user.job[index]);
                            return CardItem(
                                resultType: "job",
                                facilityName: result['facility_name'],
                                address: result['address'],
                                telephoneNumber: result['telephone_number'],
                                );
                          } ))
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
