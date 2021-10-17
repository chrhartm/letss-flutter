import 'package:flutter/material.dart';

import 'cards.dart';
import 'myactivities.dart';
import 'profile.dart';
import 'chats.dart';
import '../backend/analyticsservice.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;
  List<String> screennames = [
    '/activities',
    '/myactivities',
    '/chats',
    '/profile'
  ];

  void _onItemTapped(int index) {
    analytics.setCurrentScreen(screenName: screennames[index]);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = _getWidgetOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pan_tool),
            label: 'My Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  List<Widget> _getWidgetOptions() {
    return [
      Cards(),
      MyActivities(),
      Chats(),
      Profile(),
    ];
  }
}
