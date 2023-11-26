import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:net/config/imported.dart';
import 'package:net/pages/resources/shelter_cards/shelter_cards.dart';

class SheltersPage extends StatefulWidget {
  const SheltersPage({Key? key}) : super(key: key);

  @override
  State<SheltersPage> createState() => _SheltersPageState();
}

class _SheltersPageState extends State<SheltersPage> {
  var shelterData;
  var housingData;
  Icon fav = const Icon(Icons.star_border);

  Future<void> _fetchData() async {
    try {
      final shelterResponse = await http.get(Uri.parse(
          'https://data.orghunter.com/v1/charitysearch?user_key=ada9f57c9b97ab634db6635fd3004f72&searchTerm=shelter&city=Sacramento'));

      final housingResponse = await http.get(Uri.parse(
          'https://data.orghunter.com/v1/charitysearch?user_key=ada9f57c9b97ab634db6635fd3004f72&city=Sacramento&category=L'));

      if (shelterResponse.statusCode == 200 &&
          housingResponse.statusCode == 200) {
        shelterData = jsonDecode(shelterResponse.body);
        housingData = jsonDecode(housingResponse.body);
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (shelterData == null || housingData == null)
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: Gui.header("Shelters"),
            body: ListView(
              children: [
                for (var result in shelterData['data'])
                  ShelterCards(
                    charityName: result['charityName'],
                    url: result['url'],
                    zipCode: result['zipCode'],
                  ),
                for (var result in housingData['data'])
                  ShelterCards(
                      charityName: result['charityName'],
                      url: result['url'],
                      zipCode: result['zipCode'])
              ],
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
}
