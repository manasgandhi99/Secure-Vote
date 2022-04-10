// import 'package:e_vote/Election/electionPage.dart';
// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:secure_vote/Pages/JoinElection/electionPage.dart';
import 'package:secure_vote/Utils/loading.dart';
import 'package:web3dart/web3dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../blockchain/blockchain.dart';

class ElectionFeed extends StatefulWidget {
  const ElectionFeed({Key? key}) : super(key: key);

  @override
  State<ElectionFeed> createState() => _ElectionFeedState();
}

class _ElectionFeedState extends State<ElectionFeed> {
  bool loading = true;
  String apiUrl =
      "https://ropsten.infura.io/v3/fc3a18ef9bd9423bb6189a6381082e32";
  int electionCount = 0;
  var ethereumClient; 
  late DocumentSnapshot userSnapshot;
  late List<String> electionIds;
  late String? userEmail;
  bool isJoining = false;

  fetchData() async {
    print("==================================Fetching data..." +ethereumClient.toString());
    List<dynamic> list =
        await Blockchain().query('electionCount', [], ethereumClient);
    print("Data fetched");

    electionCount = list[0].toInt();
    print(electionCount);
    if (FirebaseAuth.instance.currentUser != null) {
      userEmail = FirebaseAuth.instance.currentUser!.email;
      userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      electionIds = List<String>.from(userSnapshot['electionIds']);
      setState(() => loading = false);
    }
  }

  Future<List<dynamic>> fetchElection(int index) async {
    print("Inside fetch election");
    List<dynamic> list = await Blockchain()
        .query('elections', [BigInt.from(index)], ethereumClient);
    return list;
  }

  @override
  initState() {
    var httpClient = Client();
    print("==================api url"+apiUrl);
    ethereumClient = Web3Client(apiUrl, httpClient);
    userEmail = FirebaseAuth.instance.currentUser!.email;
    fetchData();
    super.initState();
  }

  final TextEditingController _codeController = TextEditingController();
  int userElections = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: loading
          ? Loading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: electionCount,
                  itemBuilder: (BuildContext context, index) {
                    return FutureBuilder(
                      future: fetchElection(index + 1),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Something went wrong!"));
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.data as List;

                          DateTime startDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  (data[3].toInt() / 1000).round());
                          DateTime endDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  (data[4].toInt() / 1000).round());

                          if (!electionIds.contains(data[0])) {
                            return const SizedBox();
                          }
                          userElections += 1;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ElectionPage(index: index + 1))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.0),
                                child: Card(
                                  elevation: 6,
                                  color: Colors.lightBlue[50],
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width: size.width * 0.08),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: size.height * 0.02),
                                          MergeSemantics(
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  data[1],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Active Till ${endDate.day}-${endDate.month}-${endDate.year}",
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            (DateTime.now()
                                                        .millisecondsSinceEpoch >
                                                    data[4].toInt())
                                                ? 'Election is Over'
                                                : 'Election is Active',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }
                        return const CircularProgressIndicator();
                      },
                    );
                  },
                ),
                userElections == 0
                    ? const Center(
                        child: Text(
                            "You have not enrolled in any upcoming elections!"))
                    : const SizedBox()
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showDialog(context);
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Join Election"),
      actions: [
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        MaterialButton(
            textColor: Colors.black,
            color: Colors.green,
            child: const Text('JOIN'),
            onPressed: () async {
              //Check if the user has already been registered
              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userEmail)
                  .get();
              electionIds = List<String>.from(userDoc['electionIds']);
              
              bool isValid = false;
              if (electionIds.contains(_codeController.text.trim())) {
                //Show Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('You have already registered in this election!'),
                  ),
                );
              } else {
                //Check if the election code is valid
                isValid = false;
                for (int i = 1; i <= electionCount; i++) {
                  List<dynamic> result = await Blockchain()
                      .query('elections', [BigInt.from(i)], ethereumClient);
                  print("result");
                  print(result);
                  if (result.isNotEmpty) {
                    if (result[0] == _codeController.text.trim()) {
                      isValid = true;
                      print("Code is valid!");
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userEmail)
                          .update({
                        'electionIds':
                            FieldValue.arrayUnion([_codeController.text])
                      });
                      print("Firebase updated");
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ElectionPage(
                                    index: i,
                                  )));
                      break;
                    }
                  }

                  if (!isValid) {
                    print("Entered code is invalid");
                    return;
                  }
                  //if the code is valid --;
                  Navigator.pop(context);
                  return;
                }
              }
            })
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Code cannot be left Empty';
              }
              return null;
            },
            controller: _codeController,
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              labelText: 'Enter Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
