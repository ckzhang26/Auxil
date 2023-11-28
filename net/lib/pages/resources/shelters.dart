import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
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
            appBar: Gui.header("Shelters", false),
            body: ListView(
              children: [
                for (var result in shelterData['data'])
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            result['zipCode'] ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${result['charityName']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "${result['url']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                // Add to database
                                onPressed: () => {},
                                icon: Icon(Icons.favorite),
                                color: Colors.red,
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                //   ListTile(
                //       leading: Text(result['zipCode']),
                //       title: Text(result['charityName']),
                //       subtitle: Text(result['url'])),
                // for (var result in housingData['data'])
                // ListTile(
                //   leading: Text(result['zipCode']),
                //   title: Text(result['charityName']),
                //   subtitle: Text(result['url']),
                // ),
              ],
            ),
            floatingActionButton: IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                              zipCode: "95819",
                            )),
                  );
                }),
          );
  }
}
