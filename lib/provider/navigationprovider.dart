import 'package:flutter/material.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/main.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/activities/search.dart';
import 'package:letss_app/screens/chats/chats.dart';
import 'package:letss_app/screens/myactivities/templates.dart';
import 'package:letss_app/screens/profile/myprofile.dart';
import 'package:provider/provider.dart';
import '../provider/routeprovider.dart';

class NavigationProvider extends ChangeNotifier {
  List<Widget> _widgetOptions = <Widget>[];
  int _selectedIndex = 0;
  int walkthroughIndex = 0;
  bool chatChanged = false;

  List<String> get _screennames {
    List<String> screennames = ['/activities'];
    screennames.addAll(['/templates', '/chats', '/myprofile']);
    return screennames;
  }

  NavigationProvider() {
    clearData();
  }

  void init() {
    _widgetOptions = _getWidgetOptions();
    _selectedIndex = 0;
    walkthroughIndex = 0;
    chatChanged = false;
    return;
  }

  void clearData() {
    _widgetOptions = [];
    _selectedIndex = 0;
    walkthroughIndex = 0;
    chatChanged = false;
    return;
  }

  List<Widget> _getWidgetOptions() {
    List<Widget> widgetOptions = [
      Search(
        back: false,
      ),
      //Cards(),
    ];
    widgetOptions.addAll([
      Templates(back: false),
      Chats(),
      MyProfile(),
    ]);
    return widgetOptions;
  }

  Widget get content {
    return _widgetOptions[_selectedIndex];
  }

  set index(int index) {
    if (chatChanged) {
      chatChanged = false;
      _widgetOptions[2] = Chats();
    }
    _selectedIndex = index;
    Provider.of<RouteProvider>(navigatorKey.currentContext!, listen: false)
        .baseRoute = _screennames[index];
    notifyListeners();
  }

  void navigateTo(String route) {
    if (chatChanged) {
      chatChanged = false;
      _widgetOptions[2] = Chats();
    }
    switch (route) {
      case '/activities':
        index = 0;
        notifyListeners();
        break;
      case '/templates':
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

  void navigateToActivityChat(BuildContext context, Activity activity) async {
    Navigator.popUntil(context, (route) => route.isFirst);
    _widgetOptions[2] = Chats(
        chatId: ChatService.generateActivityChatId(activityId: activity.uid));
    index = 2;
    chatChanged = true;
    notifyListeners();
  }

  int get index {
    return _selectedIndex;
  }

  String get activeTab {
    return _screennames[index];
  }
}
