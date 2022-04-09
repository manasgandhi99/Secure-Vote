import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'stepper.dart';

class CreateElection extends StatefulWidget {
  const CreateElection({Key? key}) : super(key: key);

  @override
  State<CreateElection> createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      String? path = file.path;
      final input = File(path ?? "").openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      print(fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => StepperForm()));
        },
        tooltip: 'Create Election',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text("Create Election"),
      ),
    );
  }
}
