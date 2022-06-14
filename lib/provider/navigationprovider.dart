import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/screens/activities/cards.dart';
import 'package:letss_app/screens/chats/chats.dart';
import 'package:letss_app/screens/myactivities/myactivities.dart';
import 'package:letss_app/screens/profile/myprofile.dart';

class NavigationProvider extends ChangeNotifier {
  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;

  List<String> get _screennames {
    List<String> screennames = ['/activities'];
    screennames.addAll(['/myactivities', '/chats', '/myprofile']);
    return screennames;
  }

  NavigationProvider() {
    clearData();
  }

  void init() {
    _widgetOptions = _getWidgetOptions();
    _selectedIndex = 0;
    return;
  }

  void clearData() {
    _widgetOptions = [];
    _selectedIndex = 0;
    return;
  }

  List<Widget> _getWidgetOptions() {
    List<Widget> widgetOptions = [
      Cards(),
    ];
    widgetOptions.addAll([
      MyActivities(),
      Chats(),
      MyProfile(),
    ]);
    return widgetOptions;
  }

  Widget get content {
    return _widgetOptions[_selectedIndex];
  }

  void set index(int index) {
    analytics.setCurrentScreen(screenName: _screennames[index]);
    _selectedIndex = index;
    notifyListeners();
  }

  void navigateTo(String route) {
    switch (route) {
      case '/activities':
        index = 0;
        break;
      case '/myactivities':
        index = 1;
        break;
      case '/chats':
        index = 2;
        break;
      case '/myprofile':
        index = 3;
        break;
      default:
        index = 0;
        break;
    }
  }

  int get index {
    return _selectedIndex;
  }

  String get activeTab {
    return _screennames[index];
  }
}
