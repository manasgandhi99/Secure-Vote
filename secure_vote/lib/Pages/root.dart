import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/Auth/Login.dart';
import 'package:secure_vote/Pages/Navigation.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Column(
              children: const [
                Text("Initializing the app..."),
                CircularProgressIndicator()
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                  "Something went wrong. Please restart the app or try to clear cache."),
            ),
          );
        }
        if (snapshot.hasData) {
          User user = snapshot.data as User;
          if (user == null) {
            return const Login();
          }
          return const BottomNav();
        }
        if ((snapshot.connectionState == ConnectionState.active) &&
            (!snapshot.hasData)) {
          return const Login();
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Please wait..."),
                SizedBox(height: 10),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }
}
