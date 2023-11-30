import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:net/config/cfg.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/mongodb.dart';

import '../../config/maps.dart' as maps;

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => JobsPageState();
}

/*

https://www.linkedin.com/jobs/search?keywords=
  &location=United States

try
https://www.linkedin.com/jobs/search?keywords=&location=&distance=25&position=1&pageNum=0

*/

class JobsPageState extends State<JobsPage> {
  final String linkBase =
      "https://www.linkedin.com/jobs/search?keywords=&location=";

  final String experience = "&f_E=1%2C2%2C3";
  final String jobType = "&f_JT=P%2CC%2CT";
  final String tail = "&position=1&pageNum=0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.body,
      appBar: Gui.header("Job Search", false),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .05,
            vertical: MediaQuery.of(context).size.height * .001),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Insert all interactables into the main widget column,
          children: <Widget>[
            // Gui helpers
            Gui.pad(25),
            Gui.button("Search", () => {findJobs()}),
          ],
        ),
      ),
    );
  }

  void findJobs() async {
    String cityName = await maps.getCityNameFromZip2(MongoDB.user.zip);
    //print("city: $city");

   //String link = linkBase + city + linkTail;
    //print("Link: $link");

    //var parser = await Chaleno().load(link);
    //inspect(parser);
  }
}
