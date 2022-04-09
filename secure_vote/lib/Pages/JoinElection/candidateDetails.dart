import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CandidateDetails extends StatefulWidget {
  const CandidateDetails({Key? key}) : super(key: key);

  @override
  State<CandidateDetails> createState() => _CandidateDetailsState();
}

class _CandidateDetailsState extends State<CandidateDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                _showDialog(context);
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
                       const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 60.0,
                        child: CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider( "https://picsum.photos/200/300"),
                              radius: 50),
                        ),
                      ),
                      SizedBox(width: size.width * 0.08),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MergeSemantics(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Candidate Name",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Candidate Age",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Candidate Proposal",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey),
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
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AlertDialog alert = AlertDialog(
      title: const Text("Do you wish to vote for this candidate?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Candidate Name"),
          SizedBox(height: size.height * 0.02),
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: MaterialButton(
              height: 50,
              color: Colors.blue,
              textColor: Colors.black,
              onPressed: () {
                // Navigator.pop(context);
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
