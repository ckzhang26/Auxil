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

Sacramento example linkedIn:
https://www.linkedin.com/jobs/search?keywords=&location=Sacramento%2C%20California%2C%20United%20States&geoId=101857797&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0

main:
https://www.linkedin.com/jobs/search?keywords=&location=

remainder:
Sacramento%2C%20California%2C%20United%20States&geoId=101857797

tail:
&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0


Turlock example linkedIn:
https://www.linkedin.com/jobs/search?keywords=&location=Turlock%2C%20California%2C%20United%20States&geoId=104337712&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0

main:
https://www.linkedin.com/jobs/search?keywords=&location=

remainder:
Turlock%2C%20California%2C%20United%20States&geoId=104337712

tail:
&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0

Workable:
https://www.linkedin.com/jobs/search?keywords=&location=Turlock&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0
*/

class JobsPageState extends State<JobsPage> {
  final String linkBase =
      "https://www.linkedin.com/jobs/search?keywords=&location=";
  final String linkTail =
      "&trk=public_jobs_jobs-search-bar_search-submit&position=1&pageNum=0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Config.yellow,
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
    print("zip: ${MongoDB.user.zip}");

    String city = await maps.getCityNameFromZip2(MongoDB.user.zip);
    print("city: $city");
    
    String link = linkBase + city + linkTail;
    print("Link: $link");

    var parser = await Chaleno().load(link);
    inspect(parser);
  }
}
