// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'dart:math';
import "package:flutter/material.dart";
import "package:net/config/cfg.dart";
import "package:net/config/gui.dart";
import "package:net/main.dart";
import "package:net/pages/resources/card_item.dart";
import "package:net/pages/resources/map_view.dart";
import "package:net/user/mongodb.dart";

import "package:http/http.dart" as http;
import "package:html/dom.dart" as dom;
import "package:provider/provider.dart";

import "../../config/maps.dart" as maps;

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => JobsPageState();
}

class JobsPageState extends State<JobsPage> {
  final String normal =
      "https://www.linkedin.com/jobs/search?keywords=&location=";
  final String experience = "";
  final String jobType = "";
  final String tail = "&f_E=1%2C2%2C3&f_JT=P%2CC%2CT&position=1&pageNum=0";
  final String postingIdentifier =
      "base-card relative w-full hover:no-underline focus:no-underline base-card--link base-search-card base-search-card--link job-search-card job-search-card--active";

  @override
  void initState() {
    super.initState();
    _scrape();
    ();
  }

  List<String>? titles, urls, companies, dates, locations;
  int? jobCount;

  @override
  Widget build(BuildContext context) {
    return jobCount == null
        ? const Center(child: CircularProgressIndicator())
        : (jobCount == 0 ? Gui.label("Error getting Jobs from provider\nPlease try again later", 20) : Scaffold(
            appBar: Gui.header("Job Search", false),
            body: ListView.builder(
                itemCount: jobCount,
                itemBuilder: (BuildContext context, int index) {
                  return CardItem(
                    facilityName: titles![index],
                    url: urls![index],
                    address: "Employer: ${companies![index]}",
                    telephoneNumber: "Posted ${dates![index]}",
                  );
                }),
          ));
  }

  Future _scrape() async {
    String cityName = await maps.getCityNameFromZip2(MongoDB.user.zip);
    String link =
        "$normal$cityName&distance=5&f_E=1%2C2%2C3&f_JT=P%2CC%2CT&position=1&pageNum=0";
    print(link);

    final url = Uri.parse(link);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    titles = html
        .querySelectorAll("li > div > a:nth-child(1) > span")
        .map((element) => element.innerHtml.trim())
        .toList();

    urls = html
        .querySelectorAll("li > div > a:nth-child(1)")
        .map((element) => element.attributes["href"])
        .cast<String>()
        .toList();

    companies = html
        .querySelectorAll("h4 > a")
        .map((element) => element.innerHtml.trim())
        .toList();

    dates = html
        .querySelectorAll("div > div > time")
        .map((element) => element.innerHtml.trim())
        .toList();

    if (titles == null || urls == null || companies == null || dates == null) {
      Gui.notify(context, "Error getting jobs");
      jobCount = 0;
      setState(() {});
      return;
    }

    jobCount = [titles!.length, urls!.length, companies!.length, dates!.length]
        .reduce(min);

    // Update pins 
    Provider.of<GoogleMapsMarkerList>(context, listen: false).clear();
    


    setState(() {});
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
