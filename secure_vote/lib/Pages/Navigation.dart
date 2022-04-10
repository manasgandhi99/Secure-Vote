import 'package:flutter/material.dart';
import 'package:secure_vote/Pages/CreateElection/CreateElection.dart';
import 'package:secure_vote/Pages/voterProfile.dart';
import 'package:secure_vote/Services/authServices.dart';
import 'feed.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<String> appBarTitle = <String>[
    "Feed",
    "Create Election",
    "Profile",
  ];

  static const List<Widget> _widgetOptions = <Widget>[
    ElectionFeed(),
    CreateElection(),
    VoterProfile(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Text(appBarTitle[_selectedIndex]),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () {AuthServices.signOut();}),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Election Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Your Elections'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
