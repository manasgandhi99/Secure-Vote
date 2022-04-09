import 'package:flutter/material.dart';

class ElectionResults extends StatefulWidget {
  const ElectionResults({Key?key}) : super(key: key);

  @override
  State<ElectionResults> createState() => _ElectionResultsState();
}

class _ElectionResultsState extends State<ElectionResults> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No Results"),
    );
  }
}