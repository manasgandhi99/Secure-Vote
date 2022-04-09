
import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/JoinElection/candidateDetails.dart';
import 'package:secure_vote/Pages/JoinElection/electionDetails.dart';
import 'package:secure_vote/Pages/JoinElection/electionResult.dart';

class ElectionPage extends StatefulWidget {
  const ElectionPage({Key?key}) : super(key: key);

  @override
  State<ElectionPage> createState() => _ElectionPageState();
}

class _ElectionPageState extends State<ElectionPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.short_text_sharp)),
                Tab(icon: Icon(Icons.person_pin_sharp)),
                Tab(icon: Icon(Icons.table_chart)),
              ],
            ),
            title:  Text('Election Page'),
          ),
          body: const TabBarView(

            children: [
              ElectionDetails(),
              CandidateDetails(),
              ElectionResults(),
            ],
          ),
        ),
      ),
    );
  }
}

