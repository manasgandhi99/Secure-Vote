import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:http/http.dart';
import 'package:secure_vote/Utils/loading.dart';
import 'package:secure_vote/blockchain/blockchain.dart';
import 'package:web3dart/web3dart.dart';
import 'stepper.dart';

class CreateElection extends StatefulWidget {
  const CreateElection({Key? key}) : super(key: key);

  @override
  State<CreateElection> createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  bool loading = true;
  String apiUrl = "http://localhost:7545";
  int electionCount = 0;
  var httpClient = Client();
  var ethereumClient;

  fetchData() async {
    ethereumClient = Web3Client(apiUrl, httpClient);
    List<dynamic> list =
        await Blockchain().query('electionCount', [], ethereumClient);
    electionCount = list[0].toInt();

    // List<dynamic> list = await Blockchain().query('elections', [BigInt.from(2)], ethereumClient);
    print(list);
    setState(() => loading = false);
    // String result = await Blockchain().transaction('createElection', ['testcode','Student Council GSec', BigInt.from(4), BigInt.from(1649512433), BigInt.from(1649599999), ['Akshar','Yash','Rajan','Manas'], [EthereumAddress.fromHex('0x24E2823D982bFFC1441F941d1587c4EEe35EE4ed')]], ethereumClient, '8b54c6ccd87bacf4889dd25ce67755b818b5e09d781676d895cf57ab7a64479b');
    // print("Resukt: "+ result);
  }

  Future<List<dynamic>> fetchElection(int index) async {
    List<dynamic> list = await Blockchain()
        .query('elections', [BigInt.from(index)], ethereumClient);
    return list;
  }

  @override
  initState() {
    fetchData();
    super.initState();
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      String? path = file.path;
      final input = File(path ?? "").openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      print(fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  for (int i = 1; i <= electionCount; i++)
                    FutureBuilder(
                      future: fetchElection(i),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        } else {
                          final data = snapshot.data ;
                          if(data !=null){
                          return Container(
                            child: Column(children: [Text(data[1]),]),
                          );}
                        }
                      }),
                    )
                ],
              ),
            ),
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
    );
  }
}
