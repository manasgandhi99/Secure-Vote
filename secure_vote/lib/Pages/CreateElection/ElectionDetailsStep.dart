import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/JoinElection/candidateDetails.dart';
import 'package:secure_vote/Pages/JoinElection/electionResult.dart';

class ElectionDetailsStep extends StatefulWidget {
  final int index;
  const ElectionDetailsStep({required this.index});
  // const ElectionDetailsStep({ Key? key }) : super(key: key);

  @override
  State<ElectionDetailsStep> createState() => _ElectionDetailsStepState();
}

class _ElectionDetailsStepState extends State<ElectionDetailsStep> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                // Tab(icon: Icon(Icons.short_text_sharp)),
                // Tab(icon: Icon(Icons.person_pin_sharp)),
                Tab(icon: Icon(Icons.table_chart)),
              ],
            ),
            title:  const Text('Election Page'),
          ),
          body: TabBarView(

            children: [
              // ElectionDetails(index: widget.index),
              // CandidateDetails(index: widget.index),
              ElectionResults(index:widget.index),
            ],
          ),
        ),
      );
  }
}