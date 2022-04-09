import 'package:flutter/material.dart';


class ElectionFeed extends StatefulWidget {
  const ElectionFeed({Key? key}) : super(key: key);

  @override
  State<ElectionFeed> createState() => _ElectionFeedState();
}

class _ElectionFeedState extends State<ElectionFeed> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, index){
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Election Name"),
                SizedBox(height: size.height*0.02),

                Text("Election Description"),
                SizedBox(height: size.height*0.02),
                Text("Election Status"),
                

              ],),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        
        onPressed: (){

        },
      ),
      
    );
  }
}