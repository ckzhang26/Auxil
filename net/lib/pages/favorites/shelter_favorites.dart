
import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/resources/card_item.dart';
import 'package:net/user/mongodb.dart';
import 'dart:convert';

import '../resources/map_view.dart';

class ShelterFavoritesPage extends StatefulWidget {
  final String zipCode;

  const ShelterFavoritesPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<ShelterFavoritesPage> createState() => _ShelterFavoritesPageState();
}

class _ShelterFavoritesPageState extends State<ShelterFavoritesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: Gui.headerWelcome("Shelter Favorites", false, context,
                const Icon(Icons.my_location), mapView),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: MongoDB.user.shelter.length,
                        itemBuilder: (BuildContext context, int index) {
                          var result = json.decode(MongoDB.user.shelter[index]);
                            return CardItem(
                                resultType: "shelter",
                                isFavorite: true,
                                charityName: result['charityName'],
                                url: result['url'],
                                zipCode: result['zipCode']);
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
