import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:secure_vote/blockchain/blockchain.dart';
import 'package:web3dart/web3dart.dart';
import 'package:secure_vote/Utils/loading.dart';

class ElectionDetails extends StatefulWidget {
  final int index;
  const ElectionDetails({required this.index});

  @override
  State<ElectionDetails> createState() => _ElectionDetailsState();
}

class _ElectionDetailsState extends State<ElectionDetails> {
  var httpClient = Client();
  var ethereumClient;
  String apiUrl =
      "https://ropsten.infura.io/v3/fc3a18ef9bd9423bb6189a6381082e32";

  Future<List<dynamic>> fetchElection(int index) async {
    List<dynamic> list = await Blockchain()
        .query('elections', [BigInt.from(index)], ethereumClient);
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
      body: FutureBuilder<Object>(
          future: fetchElection(widget.index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            final data = snapshot.data as List;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                  10, size.height * 0.2, 10, size.height * 0.2),
              child: Card(
                color: Colors.lightBlue[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.8,
                        child: Text(
                          data[1],
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.004),
                        child: const Divider(thickness: 1.5),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.25,
                            child: const Text(
                              'Election Code: ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              data[0],
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.25,
                            child: const Text(
                              'Status: ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              (DateTime.now().millisecondsSinceEpoch >
                                      data[4].toInt())
                                  ? 'Election is Over'
                                  : 'Election is Active',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.25,
                            child: const Text(
                              'Start Date: ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'startDate',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.25,
                            child: const Text(
                              'End Date: ',
                              style:  TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat.yMMMMd().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    data[4].toInt())),
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
