import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:net/config/nearbyvethospitals.dart';
import 'package:net/main.dart';
import 'package:provider/provider.dart';
import 'package:net/user/mongodb.dart';
import 'package:net/pages/resources/card_item.dart';

import '../../config/maps.dart' as maps;
import 'map_view.dart';

class VeterinaryPage extends StatefulWidget {
   final String zipCode;
  
  const VeterinaryPage({Key? key, this.zipCode = "95819"}) : super(key: key);

  @override
  State<VeterinaryPage> createState() => _VeterinaryPageState();
}

class _VeterinaryPageState extends State<VeterinaryPage> {
  String apiKey = "AIzaSyC1RuhYlMwVwWMn6RZwjBuzvECC298vpgM";
  String radius = "3000";
  var vetData;

  NearbyVetHospitals nearbyVetsResponse = NearbyVetHospitals();
  
  Future<void> _getNearbyVetHospitals() async {
    String latLng = await maps.getLatLngFromZipString(MongoDB.user.zip);
    String city = await maps.getCityNameFromZip2(MongoDB.user.zip);
    print(city);
    final url = Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=veterinary_care&location=" + latLng + '&radius=' + radius + '&key=' + apiKey
  );

  final vetResponse = await http.post(url);
  if (vetResponse.statusCode == 200){
    nearbyVetsResponse = NearbyVetHospitals.fromJson(jsonDecode(vetResponse.body));
    vetData = jsonDecode(vetResponse.body);
  
    Provider.of<GoogleMapsMarkerList>(context, listen: false).clear();
    for (int i = 0; i < nearbyVetsResponse.results!.length; i++) {
        if (nearbyVetsResponse.results![i].geometry!.location!.lat != null && nearbyVetsResponse.results![i].geometry!.location!.lng != null){
        double lat2 = nearbyVetsResponse.results![i].geometry!.location!.lat!;
        double lng2 = nearbyVetsResponse.results![i].geometry!.location!.lng!;
        String vetName = nearbyVetsResponse.results![i].name!;

        LatLng coords = LatLng(lat2, lng2);
        Marker marker = Marker(
            markerId: MarkerId(nearbyVetsResponse.results![i].name!), 
            position: coords,
            infoWindow: InfoWindow(title: vetName),
        );
        Provider.of<GoogleMapsMarkerList>(context, listen: false)
            .addValue(marker);
        }
    }
    
    
    setState(() {});
    }

  }

  @override
  void initState() {
    super.initState();
    _getNearbyVetHospitals();
  }

  @override
  Widget build(BuildContext context) {
    return (vetData == null)
    ? const Center(child: CircularProgressIndicator())
    :Scaffold(
      appBar: Gui.headerWelcome("Veterinary", false, context,
          const Icon(Icons.my_location), mapView),

      body: Column(
        children: [
          Expanded(
            child: ListView(
                  children: [
                    if (nearbyVetsResponse != null)
                      for (int i = 0; i < nearbyVetsResponse.results!.length; i++)
                        nearbyPlacesWidget(nearbyVetsResponse.results![i])
                  ],
                ),
           ),
        ],
      ),
    );
  }


  Widget nearbyPlacesWidget(Results results) {
        return CardItem(
        facilityName: results.name,
        address: results.vicinity,
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