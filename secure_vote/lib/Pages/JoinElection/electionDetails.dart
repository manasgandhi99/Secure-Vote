import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ElectionDetails extends StatefulWidget {
  const ElectionDetails({Key?key}) : super(key: key);

  @override
  State<ElectionDetails> createState() => _ElectionDetailsState();
}

class _ElectionDetailsState extends State<ElectionDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, size.height*0.2, 10, size.height*0.2),
        child: Card(
          color: Colors.lightBlue[50],
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.8,
                  child: Text(
                    "Election Name",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.004),
                  child: Divider(thickness: 1.5),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      child: Text(
                        'Description: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "Description",
                        style: TextStyle(
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
                    Container(
                      width: size.width * 0.25,
                      child: Text(
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
                        "Ongoing",
                        style: TextStyle(
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
                    Container(
                      width: size.width * 0.25,
                      child: Text(
                        'Start Date: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMd().format(DateTime.parse("20220409")),
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      child: Text(
                        'End Date: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMd().format(DateTime.parse("20220414")),
                      style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}