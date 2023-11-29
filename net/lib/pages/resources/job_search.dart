import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';

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

*/

class JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Job Search", false),
    );
  }
}