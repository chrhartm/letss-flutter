import 'package:flutter/material.dart';
import '../provider/userprovider.dart';
import '../provider/chatsprovider.dart';
import 'cards.dart';
import 'likes.dart';
import 'profile.dart';
import 'chats.dart';
import 'package:provider/provider.dart';
import '../provider/activitiesprovider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => ActivitiesProvider()),
        ChangeNotifierProvider(create: (context) => ChatsProvider()),
      ], child: HomeWithProvider());
    });
  }
}

class HomeWithProvider extends StatefulWidget {
  const HomeWithProvider({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeWithProvider> {
  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
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
            label: 'Likes',
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
        selectedItemColor: Colors.amber[800],
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
      Likes(),
      Chats(),
      Profile(),
    ];
  }
}
