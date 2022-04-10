import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../../Utils/loading.dart';
import '../../blockchain/blockchain.dart';

class ElectionResults extends StatefulWidget {
  final int index;
  // ignore: use_key_in_widget_constructors
  const ElectionResults({required this.index});

  @override
  State<ElectionResults> createState() => _ElectionResultsState();
}

class _ElectionResultsState extends State<ElectionResults> {
  var httpClient = Client();
  String apiUrl =
      "https://ropsten.infura.io/v3/fc3a18ef9bd9423bb6189a6381082e32";
  var ethereumClient;
  late int numCandidates;

  Future<List<dynamic>> fetchElection(int index) async {
    List<dynamic> list = await Blockchain()
        .query('elections', [BigInt.from(index)], ethereumClient);
    numCandidates = list[2].toInt();
    return list;
  }

  @override
  void initState() {
    ethereumClient = Web3Client(apiUrl, httpClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Election Result")),
      body: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )),
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.005, horizontal: 5),
              child: Row(
                children: [
                  SizedBox(
                      width: size.width * 0.2,
                      child: const Text("Rank",
                          style: TextStyle(color: Colors.black, fontSize: 15))),
                  SizedBox(
                      width: size.width * 0.4,
                      child: const Text("Name",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14))),
                  SizedBox(
                      width: size.width * 0.3,
                      child: const Text("Number of Votes",
                          style: TextStyle(color: Colors.black, fontSize: 13))),
                  // Container(child: Text("Points", style: TextStyle(color: Colors.black, fontSize: 11))),
                ],
              ),
            ),
            FutureBuilder<Object>(
                future: fetchElection(widget.index),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  }
                  final data = snapshot.data as List;
                  final numCan = data[2].toInt();
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: numCan,
                      itemBuilder: (context, index) {
                        // List<dynamic> result = await ;
                        return FutureBuilder<Object>(
                            future: Blockchain().query(
                                'getCandidate',
                                [BigInt.from(widget.index), BigInt.from(index)],
                                ethereumClient),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasData) {
                                final res = snapshot.data as List;
                                return FutureBuilder<Object>(
                                  future: Blockchain().query(
                                      'getVotes',
                                      [BigInt.from(widget.index), res[0]],
                                      ethereumClient),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final voteCount = snapshot.data as List;

                                      return Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Row(
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            size.width * 0.04),
                                                    width: size.width * 0.2,
                                                    child:
                                                        Text(index.toString())),
                                                SizedBox(
                                                    width: size.width * 0.5,
                                                    child: Text(
                                                      res[0],
                                                      softWrap: true,
                                                    )),
                                                SizedBox(
                                                    width: size.width * 0.1,
                                                    child: Text(
                                                        voteCount.toString(),
                                                        softWrap: true)),
                                                // Container(
                                                //     child: Text(performanceData[index]["Points"],
                                                //         softWrap: true)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.height * 0.004),
                                            child:
                                                const Divider(thickness: 1.5),
                                          ),
                                        ],
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                );
                              }
                              return const CircularProgressIndicator();
                            });
                      });
                })
          ]))),
    );
  }
}
