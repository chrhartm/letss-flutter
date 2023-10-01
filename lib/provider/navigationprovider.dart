import 'package:flutter/material.dart';
import 'package:letss_app/screens/activities/search.dart';
import 'package:letss_app/screens/chats/chats.dart';
import 'package:letss_app/screens/myactivities/myactivities.dart';
import 'package:letss_app/screens/profile/myprofile.dart';

class NavigationProvider extends ChangeNotifier {
  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;
  int walkthroughIndex = 0;

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
    walkthroughIndex = 0;
    return;
  }

  void clearData() {
    _widgetOptions = [];
    _selectedIndex = 0;
    walkthroughIndex = 0;
    return;
  }

  List<Widget> _getWidgetOptions() {
    List<Widget> widgetOptions = [
      Search(back: false,),
      //Cards(),
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

  set index(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void navigateTo(String route) {
    switch (route) {
      case '/activities':
        index = 0;
        notifyListeners();
        break;
      case '/myactivities':
        index = 1;
        notifyListeners();
        break;
      case '/chats':
        index = 2;
        notifyListeners();
        break;
      case '/myprofile':
        index = 3;
        notifyListeners();
        break;
      default:
        index = 0;
        notifyListeners();
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
