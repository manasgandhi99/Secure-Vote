import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:secure_vote/Pages/CreateElection/ElectionDetailsStep.dart';
import 'package:secure_vote/Pages/JoinElection/electionResult.dart';
import 'package:secure_vote/Utils/loading.dart';
import 'package:secure_vote/blockchain/blockchain.dart';
import 'package:web3dart/web3dart.dart';
import 'package:secure_vote/Pages/CreateElection/stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateElection extends StatefulWidget {
  const CreateElection({Key? key}) : super(key: key);

  @override
  State<CreateElection> createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  bool loading = true;
  String apiUrl =
      "https://ropsten.infura.io/v3/fc3a18ef9bd9423bb6189a6381082e32";
  int electionCount = 0;
  var httpClient = Client();
  var ethereumClient;
  late DocumentSnapshot userSnapshot;
  late List<String> electionIds;

  fetchData() async {
    // ethereumClient = Web3Client(apiUrl, httpClient);
    List<dynamic> list =
        await Blockchain().query('electionCount', [], ethereumClient);
        electionCount = list[0].toInt();

        print("election count: " + electionCount.toString());

    // List<dynamic> list = await Blockchain().query('elections', [BigInt.from(2)], ethereumClient);
    // print(list);
    if (FirebaseAuth.instance.currentUser != null) {
      String? userEmail = FirebaseAuth.instance.currentUser!.email;
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      electionIds = List<String>.from(userSnapshot['createdElectionIds']);
      setState(() => loading = false);
    }

  }

  Future<List<dynamic>> fetchElection(int index) async {
    List<dynamic> list = await Blockchain()
        .query('elections', [BigInt.from(index)], ethereumClient);
    return list;
  }

  @override
  initState() {
    ethereumClient = Web3Client(apiUrl, httpClient);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: loading
          ? Loading()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (int i = 1; i <= electionCount; i++)
                    FutureBuilder(
                      future: fetchElection(i),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        } else {
                          final data = snapshot.data as List;
                          
                          if (!electionIds.contains(data[0])) {
                            return InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectionResults(index:i)));
                              },
                              child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: Card(
                                elevation: 6,
                                color: Colors.lightBlue[50],
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: size.width * 0.035,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        MergeSemantics(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Election Name: " + data[1].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Number of Candidates: " + data[2].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Start Date: " + data[3].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "End Date: " + data[4].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ),
                          ),
                            );
                          }
                          print("snapshot.data: ");
                          print(snapshot.data);
                          
                          return InkWell(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectionResults(index:i)));
                              },
                                  child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Card(
                                    elevation: 6,
                                    color: Colors.lightBlue[50],
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: size.width * 0.035,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            MergeSemantics(
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Election Name: " + data[1].toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Number of Candidates: " + data[2].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Start Date: " + data[3].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "End Date: " + data[4].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                              ),
                            );
                        }
                      }),
                    ),
                  electionCount == 0
                      ? const Center(
                          child:
                              Text("You have not created any elections yet!"),
                        )
                      : const SizedBox()
                  // const SizedBox()
                  // ListView.builder(
                  //   itemCount: electionCount,
                  //   itemBuilder: (context, index)
                  //   {
                  //     return Card(
                  //       child: data[index],
                  //     );
                  //   }
                  // )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateElectionForm()));
        },
        tooltip: 'Create Election',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
