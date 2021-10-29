import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'activities/cards.dart';
import 'myactivities/myactivities.dart';
import 'profile/myprofile.dart';
import 'chats/chats.dart';
import '../backend/analyticsservice.dart';
import '../provider/notificationsprovider.dart';

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
    '/myprofile'
  ];

  void Function(int) _onItemTappedWrapper(NotificationsProvider notifications) {
    return (int index) {
      return _onItemTapped(index, notifications);
    };
  }

  void _onItemTapped(int index, NotificationsProvider notifications) {
    analytics.setCurrentScreen(screenName: screennames[index]);
    notifications.activeTab = screennames[index];

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = _getWidgetOptions();
  }

  Widget _iconWithNotification(
      {required Icon icon,
      bool notification = false,
      Color notificationColor = Colors.red}) {
    List<Widget> stack = [icon];
    if (notification) {
      stack.add(Positioned(
          right: 0,
          child: Stack(alignment: Alignment.center, children: [
            Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 8,
                minHeight: 8,
              ),
            ),
            Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: notificationColor,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 5,
                minHeight: 5,
              ),
            ),
          ])));
    }
    return Stack(children: stack);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
        builder: (context, notifications, child) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'Activities',
            ),
            BottomNavigationBarItem(
              icon: _iconWithNotification(
                  icon: Icon(Icons.pan_tool),
                  notification: notifications.newLikes,
                  notificationColor: Theme.of(context).colorScheme.error),
              label: 'My Activities',
            ),
            BottomNavigationBarItem(
              icon: _iconWithNotification(
                  icon: Icon(Icons.chat_bubble),
                  notification: notifications.newMessages,
                  notificationColor: Theme.of(context).colorScheme.error),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
          onTap: _onItemTappedWrapper(notifications),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
        ),
      );
    });
  }

  List<Widget> _getWidgetOptions() {
    return [
      Cards(),
      MyActivities(),
      Chats(),
      MyProfile(),
    ];
  }
}
