// ignore_for_file: avoid_print

import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:secure_vote/Utils/constantStrings.dart';
import 'package:secure_vote/blockchain/blockchain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:secure_vote/Utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CandidateDetails extends StatefulWidget {
  final int index;
  const CandidateDetails({Key? key, required this.index}) : super(key: key);

  @override
  State<CandidateDetails> createState() => _CandidateDetailsState();
}

class _CandidateDetailsState extends State<CandidateDetails> {
  var httpClient = Client();
  String apiUrl =
      "https://ropsten.infura.io/v3/fc3a18ef9bd9423bb6189a6381082e32";
  var ethereumClient;
  late int numCandidates;
  late String? userEmail;

  Future<List<dynamic>> fetchElection(int index) async {
    List<dynamic> list = await Blockchain()
        .query('elections', [BigInt.from(index)], ethereumClient);
    numCandidates = list[2].toInt();
    return list;
  }

  fetchEmail() {
    if (FirebaseAuth.instance.currentUser != null) {
      userEmail = FirebaseAuth.instance.currentUser!.email;
    }
  }

  @override
  void initState() {
    fetchEmail();
    ethereumClient = Web3Client(apiUrl, httpClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<Object>(
        future: fetchElection(widget.index),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          final data = snapshot.data as List;
          final numCan = data[2].toInt();

          return ListView.builder(
              itemCount: numCan,
              itemBuilder: (context, index) {
                // List<dynamic> result = await ;
                return FutureBuilder<Object>(
                    future: Blockchain().query(
                        'getCandidate',
                        [BigInt.from(widget.index), BigInt.from(index)],
                        ethereumClient),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        final res = snapshot.data as List;
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () => _showDialog(context, res[0]),
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
                                    const CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 60.0,
                                      child: CircleAvatar(
                                        radius: 55.0,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    "https://picsum.photos/200/300"),
                                            radius: 50),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.08),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        MergeSemantics(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                res[0],
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    });
              });
        },
      ),
    );
  }

  void _showDialog(BuildContext context, String candidate) {
    // Size size = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
      title: const Text("Do you wish to vote for this candidate?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text("Candidate Name"),
          // SizedBox(height: size.height * 0.02),
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: MaterialButton(
              height: 50,
              color: Colors.blue,
              textColor: Colors.black,
              onPressed: () async {
                // Navigator.pop(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? privateKey =   prefs.getString(PRIVATEKEYSHAREDPREFNAME);
                print(privateKey);
                print(candidate);
                print(BigInt.from(widget.index).toString());
                String email = FirebaseAuth.instance.currentUser!.email!;
                if (privateKey != null) {
                  String result = await Blockchain().transaction(
                      'vote',
                      [BigInt.from(widget.index), candidate, email],
                      ethereumClient,
                      privateKey);
                  print("Voted!");
                  print(result);
                  List<dynamic> numVotes = await Blockchain().query('getVotes',
                      [BigInt.from(widget.index), candidate], ethereumClient);
                  print("vote count: " + numVotes[0].toString());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Vote has been casted successfully! It will be reflected in short time'),
                  ),
                );
                }
              },
              child: const Text('VOTE!'),
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
