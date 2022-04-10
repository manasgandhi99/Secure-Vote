
import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/JoinElection/candidateDetails.dart';
import 'package:secure_vote/Pages/JoinElection/electionDetails.dart';
import 'package:secure_vote/Pages/JoinElection/electionResult.dart';

class ElectionPage extends StatefulWidget {
  final int index;
  const ElectionPage({required this.index});

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
            title:  const Text('Election Page'),
          ),
          body: TabBarView(

            children: [
              ElectionDetails(index: widget.index),
              CandidateDetails(index: widget.index),
              ElectionResults(index:widget.index),
            ],
          ),
        ),
      ),
    );
  }
}

