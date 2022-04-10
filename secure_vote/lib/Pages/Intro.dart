import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/Auth/Login.dart';
import 'package:secure_vote/Pages/root.dart';

class Intro extends StatelessWidget {
  const Intro({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [const Text("Secure Vote"), const SizedBox(height:25),MaterialButton(color: Colors.blue, child: const Text("Continue to the App"), onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=> RootPage()));}),]),
    );
  }
}