import 'package:flutter/material.dart';
import 'package:xpressready/screen/emergency_service_screen.dart';
import 'package:xpressready/screen/setting_screen.dart';
import 'recent_accident_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  // List<dynamic> data = jsonDecode(importData);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const RecentCrashScreen(),
    const EmergencyServiceScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    var padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        backgroundColor: const Color(0xFFC6EBC5),
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}