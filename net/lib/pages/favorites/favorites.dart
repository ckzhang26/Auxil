import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/pages/favorites/healthcare_favorites.dart';
import 'package:net/pages/favorites/jobs_favorites.dart';
import 'package:net/pages/favorites/veterinary_favorites.dart';
import 'package:net/user/mongodb.dart';

import '../resources/map_view.dart';
import 'shelter_favorites.dart';

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

}