import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:letss_app/screens/activities/cards.dart';
import 'package:letss_app/screens/chats/chats.dart';
import 'package:letss_app/screens/myactivities/myactivities.dart';
import 'package:letss_app/screens/profile/myprofile.dart';
import 'package:letss_app/screens/search/search.dart';

class NavigationProvider extends ChangeNotifier {
  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;

  List<String> get _screennames {
    List<String> screennames = ['/activities'];
    if (RemoteConfigService.featureSearch) {
      screennames.add('/search');
    }
    screennames.addAll(['/myactivities', '/chats', '/myprofile']);
    return screennames;
  }

  ChatsProvider() {
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
    if (RemoteConfigService.featureSearch) {
      widgetOptions.add(Search());
    }
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
    int addSearch =
        RemoteConfigService.featureSearch ? 1 : 0;
    switch (route) {
      case '/activities':
        index = 0;
        break;
      case '/search':
        index = 1;
        break;
      case '/myactivities':
        index = 1 + addSearch;
        break;
      case '/chats':
        index = 2 + addSearch;
        break;
      case '/myprofile':
        index = 3 + addSearch;
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
