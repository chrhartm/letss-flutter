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
      NotificationsProvider notifications,
      UserProvider user,
      NavigationProvider nav,
      BuildContext context) {
    List<BottomNavigationBarItem> options = [
      BottomNavigationBarItem(
        icon: Showcase(
            key: _two,
            disableMovingAnimation: true,
            overlayOpacity: 0.6,
            targetBorderRadius: BorderRadius.circular(100),
            targetPadding: const EdgeInsets.all(12),
            tooltipBackgroundColor: Theme.of(context).colorScheme.background,
            textColor: Theme.of(context).colorScheme.onBackground,
            description:
                'Here you can browse other\'s ideas.\nEverybody can propose more than one idea so you might see the same person more than once.',
            child: Icon(Icons.people_alt)),
        label: 'Ideas',
      ),
    ];
    options.addAll([
      BottomNavigationBarItem(
        icon: Showcase(
            key: _three,
            disableMovingAnimation: true,
            description:
                'Tap here to suggest your own ideas and to match people who asked to join you.',
            overlayOpacity: 0.6,
            targetBorderRadius: BorderRadius.circular(100),
            targetPadding: const EdgeInsets.all(12),
            tooltipBackgroundColor: Theme.of(context).colorScheme.background,
            textColor: Theme.of(context).colorScheme.onBackground,
            child: _iconWithNotification(
                icon: Icon(Icons.lightbulb),
                notification: notifications.newLikes,
                notificationColor: Theme.of(context).colorScheme.error)),
        label: 'My Ideas',
      ),
      BottomNavigationBarItem(
        icon: Showcase(
            key: _four,
            disableMovingAnimation: true,
            description: 'Once you matched with somebody, you can chat here.',
            overlayOpacity: 0.6,
            targetBorderRadius: BorderRadius.circular(100),
            targetPadding: const EdgeInsets.all(12),
            tooltipBackgroundColor: Theme.of(context).colorScheme.background,
            textColor: Theme.of(context).colorScheme.onBackground,
            child: _iconWithNotification(
                icon: Icon(Icons.chat_bubble),
                notification: notifications.newMessages,
                notificationColor: Theme.of(context).colorScheme.error)),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Showcase(
            key: _five,
            disableMovingAnimation: true,
            overlayOpacity: 0.6,
            targetBorderRadius: BorderRadius.circular(100),
            targetPadding: const EdgeInsets.all(12),
            tooltipBackgroundColor: Theme.of(context).colorScheme.background,
            textColor: Theme.of(context).colorScheme.onBackground,
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
            if (g == _one) {
              nav.walkthroughIndex = 1;
              nav.navigateTo('/activities');
            }
            if (g == _two) {
              nav.walkthroughIndex = 2;
              nav.navigateTo('/myactivities');
            }
            if (g == _three) {
              nav.walkthroughIndex = 3;
              nav.navigateTo('/chats');
            }
            if (g == _four) {
              nav.walkthroughIndex = 4;
              nav.navigateTo('/myprofile');
            }
            if (g == _five) {
              nav.showWalkthrough = false;
              nav.navigateTo('/activities');

            }
          }, builder: Builder(builder: (context) {
            if (nav.showWalkthrough) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                switch (nav.walkthroughIndex) {
                  case 0:
                    ShowCaseWidget.of(context).startShowCase([_one]);
                    break;
                  case 1:
                    ShowCaseWidget.of(context).startShowCase([_two]);
                    break;
                  case 2:
                    ShowCaseWidget.of(context).startShowCase([_three]);
                    break;
                  case 3:
                    ShowCaseWidget.of(context).startShowCase([_four]);
                    break;
                  case 4:
                    ShowCaseWidget.of(context).startShowCase([_five]);
                    break;
                }
              });
            }
            return Scaffold(
                body: SafeArea(
                  child: Center(
                    child: nav.content,
                  ),
                ),
                bottomNavigationBar: Showcase(
                  key: _one,
                  overlayOpacity: 0.6,
                  disableMovingAnimation: true,
                  tooltipBackgroundColor:
                      Theme.of(context).colorScheme.background,
                  textColor: Theme.of(context).colorScheme.onBackground,
                  description: "Welcome 👋 Let\'s do a quick tour.",
                  child: BottomNavigationBar(
                    items: _buildOptions(notifications, user, nav, context),
                    currentIndex: nav.index,
                    selectedItemColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: (index) {
                      if (nav.showWalkthrough == false) {
                        nav.index = index;
                        notifications.activeTab = nav.activeTab;
                      } else {
                        ShowCaseWidget.of(context).next();
                      }
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
