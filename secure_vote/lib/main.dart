import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/Auth/Login.dart';
import 'package:secure_vote/Pages/CreateElection/CreateElection.dart';
import 'package:secure_vote/Pages/Navigation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Secure Vote',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(title: 'Secure Vote'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: const Text("Nav"),
              color: Colors.pink,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNav()),
              ),
            ),
            MaterialButton(
              child: const Text("Create"),
              color: Colors.amber,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateElection()),
              ),
            ),
            MaterialButton(
              child: const Text("Auth"),
              color: Colors.amber,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
