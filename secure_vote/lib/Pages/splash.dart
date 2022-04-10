import 'package:secure_vote/Pages/Intro.dart';
import 'package:secure_vote/Pages/root.dart';
import 'package:secure_vote/Utils/constantStrings.dart';
import 'package:secure_vote/Utils/constants.dart';
import "package:shared_preferences/shared_preferences.dart";
// import 'package:daybook/Utils/constantStrings.dart';
// import 'package:daybook/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}):super(key:key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  startTime() async {
    var _duration = const Duration(seconds: 2);
    return Timer(_duration, navigate);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  void navigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool _seen = (prefs.getBool(SHAREDPREFNAME) ?? false);
    if (_seen) {
      /// Redirect to root page
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const RootPage()));
 }
     else{

    //  else{

    //  // eNavigator.pop(context);
    //   // // // Show Intro Screens
    //   // Navigator.popAndPushName
    Navigator.pop(context);
       Navigator.push(
           context, MaterialPageRoute(builder: (context) => const Intro()));
    // }
// 
  }

    @override
  void dispose() {
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
           begin: Alignment.bottomLeft, end: Alignment.topRight, colors: colorPalette,
          ),
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts:[
                      TyperAnimatedText("Secure Vote", 
                      textStyle: GoogleFonts.getFont("Allura", fontSize:
                          40, color: Colors.blueGrey[800], letterSpacing: 1.5
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
 
   }
 }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
