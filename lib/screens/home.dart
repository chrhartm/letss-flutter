import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/support/supportdialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import '../provider/notificationsprovider.dart';

class Home extends StatefulWidget {
  const Home({this.start = '/activities', Key? key}) : super(key: key);

  final String start;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
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

  List<BottomNavigationBarItem> _buildOptions(
      NotificationsProvider notifications) {
    List<BottomNavigationBarItem> options = [
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt),
        label: 'Activities',
      ),
    ];
    LoggerService.log("${RemoteConfigService.featureSearch}");
    ;
    if (RemoteConfigService.featureSearch) {
      options.add(BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        label: 'Search',
      ));
    }
    options.addAll([
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
    ]);
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
        builder: (context, notifications, child) {
      return Consumer<UserProvider>(builder: (context, user, child) {
        return Consumer<NavigationProvider>(builder: (context, nav, child) {
          if (user.user.requestedSupport == false &&
              user.user.person.supporterBadge == "") {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SupportDialog();
                  });
            });
          }
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: nav.content,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _buildOptions(notifications),
              currentIndex: nav.index,
              selectedItemColor: Theme.of(context).colorScheme.secondaryVariant,
              onTap: (index) {
                nav.index = index;
                notifications.activeTab = nav.activeTab;
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          );
        });
      });
    });
  }
}
