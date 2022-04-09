// import 'package:e_vote/Election/electionPage.dart';
import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/JoinElection/electionPage.dart';


class ElectionFeed extends StatefulWidget {
  const ElectionFeed({Key? key}) : super(key: key);

  @override
  State<ElectionFeed> createState() => _ElectionFeedState();
}

class _ElectionFeedState extends State<ElectionFeed> {
  
  TextEditingController _codeController = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, index){
          return Padding(
            padding:  const EdgeInsets.fromLTRB(5, 10, 5, 0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ElectionPage() ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Card(
                  elevation: 6,
                  color: Colors.lightBlue[50],
                  child: Row(
                    children: <Widget>[

                      // SizedBox(
                      //   width: size.width * 0.035,
                      // ),

                      // CircleAvatar(
                      //   backgroundColor: Colors.black,
                      //   radius: 60.0,
                      //   child: CircleAvatar(
                      //     radius: 55.0,
                      //     backgroundColor: Colors.white,
                      //     child: CircleAvatar(
                      //       backgroundImage: AssetImage("assets/voter.png"),
                      //       radius: 50,
                      //     ),
                      //   ),
                      // ),

                      SizedBox(
                        width: size.width * 0.08,
                      ),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: size.height * 0.02,
                          ),

                          MergeSemantics(
                            child: Row(
                              children: <Widget>[
                          
                                Text(
                                  "Election Name",
                                  overflow:
                                      TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: Theme.of(context)
                                          .primaryColor),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Election Description",
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Election Status",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey),
                          ),

                          SizedBox(
                            height: size.height * 0.02,
                          ),
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          _showDialog(context);
        },
      ),
      
    );
  }

   void _showDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text("Join Election"),
      actions: [
        FlatButton(
          textColor: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        FlatButton(
          textColor: Colors.black,
          onPressed: () {

          },
          child: const Text('JOIN'),
        ),
      ],
      content: Column(
        mainAxisSize:  MainAxisSize.min,
        children: [ 
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Code cannot be left Empty';
              }
              // RegExp regExp = new RegExp(EMAIL_REGEX);
              // if (!regExp.hasMatch(value)) {
              //   return 'Enter a valid email';
              // }
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