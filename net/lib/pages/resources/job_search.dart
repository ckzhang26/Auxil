import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => JobsPageState();
}

class JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Gui.header("Job Search", false),
    );
  }
}