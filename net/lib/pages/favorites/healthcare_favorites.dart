// ignore_for_file: use_build_context_synchronously

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

class HealthcareFavoritesPage extends StatefulWidget {
  final String zipCode;

  const HealthcareFavoritesPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<HealthcareFavoritesPage> createState() => _HealthcareFavoritesPageState();
}

class _HealthcareFavoritesPageState extends State<HealthcareFavoritesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: Gui.headerWelcome("Healthcare Favorites", false, context,
                const Icon(Icons.my_location), mapView),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: MongoDB.user.healthcare.length,
                        itemBuilder: (BuildContext context, int index) {
                          print("asdf");
                          var result = json.decode(MongoDB.user.healthcare[index]);
                            return CardItem(
                                resultType: "healthcare",
                                facilityName: result['facility_name'],
                                address: result['address'],
                                cityTown: result['citytown'],
                                state: result['state'],
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
