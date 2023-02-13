import 'package:flutter/material.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/support/supportdialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:showcaseview/showcaseview.dart';

import '../provider/notificationsprovider.dart';

class Home extends StatefulWidget {
  const Home({this.start = '/activities', Key? key}) : super(key: key);

  final String start;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

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
      NotificationsProvider notifications, UserProvider user) {
    List<BottomNavigationBarItem> options = [
      BottomNavigationBarItem(
        icon: Showcase(
            key: _two,
            overlayOpacity: 0.0,
            tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            description:
                'Here you can browse other\'s ideas.\nEverybody can propose more than one idea so you might see the same person more than once.\nRaise your hand if you want to join or press skip to see the others.',
            child: Icon(Icons.people_alt)),
        label: 'Ideas',
      ),
    ];
    options.addAll([
      BottomNavigationBarItem(
        icon: Showcase(
            key: _three,
            description:
                'Tap here to suggest your own ideas and to match people who asked to join you.',
            overlayOpacity: 0.0,
            tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            child: _iconWithNotification(
                icon: Icon(Icons.lightbulb),
                notification: notifications.newLikes,
                notificationColor: Theme.of(context).colorScheme.error)),
        label: 'My Ideas',
      ),
      BottomNavigationBarItem(
        icon: Showcase(
            key: _four,
            description: 'Once you matched with somebody, you can chat here.',
            overlayOpacity: 0.0,
            tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            child: _iconWithNotification(
                icon: Icon(Icons.chat_bubble),
                notification: notifications.newMessages,
                notificationColor: Theme.of(context).colorScheme.error)),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Showcase(
            key: _five,
            overlayOpacity: 0.0,
            tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            description:
                'Tap here to review your profile and access settings.\nHave fun 🥳',
            child: Icon(Icons.person)),
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
          return ShowCaseWidget(onComplete: (_, g) {
            if (g == _five) {
              nav.showWalkthrough = false;
            }
          }, builder: Builder(builder: (context) {
            if (nav.showWalkthrough) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  ShowCaseWidget.of(context)
                      .startShowCase([_one, _two, _three, _four, _five]));
            }
            return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: nav.content,
                  ),
                ),
                bottomNavigationBar: Showcase(
                  key: _one,
                  overlayOpacity: 0.0,
                  tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  description: "Welcome 👋 Let\'s do a quick tour.",
                  child: BottomNavigationBar(
                    items: _buildOptions(notifications, user),
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
                ));
          }));
        });
      });
    });
  }
}
