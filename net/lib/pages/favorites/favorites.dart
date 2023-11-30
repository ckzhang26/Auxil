import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/main.dart';
import 'package:net/pages/favorites/healthcare_favorites.dart';
import 'package:net/pages/favorites/jobs_favorites.dart';
import 'package:net/pages/favorites/veterinary_favorites.dart';
import 'package:net/pages/resources/card_item.dart';
import 'package:net/user/mongodb.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../resources/map_view.dart';
import 'shelter_favorites.dart';
import 'healthcare_favorites.dart';

class FavoritesPage extends StatefulWidget {
  final String zipCode;

  const FavoritesPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.headerWelcome("Favorites", false, context,
                const Icon(Icons.my_location), mapView), 
      body: Row(children: [
        ElevatedButton(onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShelterFavoritesPage(
                                      
                                    )),
                          ), child: Text('Shelters')),
        ElevatedButton(onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthcareFavoritesPage(
                                      
                                    )),
                          ), child: Text('Healthcare')),
        ElevatedButton(onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VeterinaryFavoritesPage(
                                      
                                    )),
                          ), child: Text("Veterinary")),
        ElevatedButton(onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JobsFavoritesPage(
                                      
                                    )),
                          ),child: Text('Jobs'),)]),);
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

  ListView showFavorites(BuildContext context, String resultType) {
    switch(resultType) {
      case 'healthcare':
      ListView.builder(itemCount: 10, itemBuilder: (BuildContext context, int index) {
        
    print('asdf');
        var result = json.decode(MongoDB.user.healthcare[index]);
        return CardItem(resultType: "healthcare",
        facilityName: result.facility_name,
        address: result.address,
        cityTown: result.cityTown,
        state: result.state,
        telephoneNumber: result.telephone_number,
        );
      });
      case 'shelter':
            return ListView.builder(itemBuilder: (BuildContext context, int index) {
        return CardItem(resultType: "shelter");
      });
      case 'veterinary':
            return ListView.builder(itemBuilder: (BuildContext context, int index) {
        return CardItem(resultType: "veterinary");
      });
      case 'jobs':
            return ListView.builder(itemBuilder: (BuildContext context, int index) {
        return CardItem(resultType: "jobs");
      });
    }
    setState(() {
      
    });
    return ListView();
    // return ListView.builder(itemBuilder: (BuildContext context, int index) => {return Placeholder()});
  }
}