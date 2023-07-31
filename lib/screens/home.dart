import 'package:flutter/material.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/support/notificationsdialog.dart';
import 'package:letss_app/screens/support/supportdialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

import '../backend/messagingservice.dart';
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
      NotificationsProvider notifications,
      UserProvider user,
      NavigationProvider nav,
      BuildContext context) {
    List<BottomNavigationBarItem> options = [
      BottomNavigationBarItem(
        icon: Icon(Icons.people_alt),
        label: 'Ideas',
      ),
    ];
    options.addAll([
      BottomNavigationBarItem(
        icon: _iconWithNotification(
            icon: Icon(Icons.lightbulb),
            notification: notifications.newLikes,
            notificationColor: Theme.of(context).colorScheme.error),
        label: 'My Ideas',
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
            SchedulerBinding.instance.addPostFrameCallback((_) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SupportDialog();
                  });
            });
          }
          // TODO whenever I update notificationsDate on firebase in user
          // the screen reloads, even if notifications are already enabled
          if (user.user.requestedNotifications == false) {
            // Check if user has notifications enabled
            // If no permissions enabled, show dialog to ask to enable
            MessagingService.notificationsEnabled().then(
              (enabled) {
                if (!enabled) {
                  MessagingService.notificationsDenied().then((denied) {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return NotificationsDialog(denied);
                        });
                  });
                  });
                }
              },
            );

            user.markNotificationsRequested();
          }
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: nav.content,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _buildOptions(notifications, user, nav, context),
              currentIndex: nav.index,
              selectedItemColor:
                  Theme.of(context).colorScheme.secondaryContainer,
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
