import 'dart:io';

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../pages/resources/map_view.dart';
import '../../config/maps.dart' as maps;

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
          "value": await maps.getCityNameFromZip2(widget.zipCode),
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
            appBar: Gui.header("Healthcare", false),
            body: ListView.builder(
                itemCount: hospitalData.length,
                itemBuilder: (BuildContext context, int index) {
                  var result = hospitalData[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(result['facility_name'] ?? ''),
                          Text(
                              "${result['address']}, ${result['citytown']} ${result['state']} ${result['zip_code']}" ??
                                  ''),
                          Text(result['telephone_number'] ?? ''),
                        ],
                      ),
                    ),
                  );
                }),
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
