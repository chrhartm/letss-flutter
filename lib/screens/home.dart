import 'package:flutter/material.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/notificationsdialog.dart';
import 'package:letss_app/screens/support/supportdialog.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:upgrader/upgrader.dart';
import 'dart:io' show Platform;

import '../backend/messagingservice.dart';
import '../provider/notificationsprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        label: AppLocalizations.of(context)!.activitiesTitle,
      ),
    ];
    options.addAll([
      BottomNavigationBarItem(
        icon: _iconWithNotification(
            icon: Icon(Icons.lightbulb),
            notification: notifications.newLikes,
            notificationColor: Theme.of(context).colorScheme.error),
        label: AppLocalizations.of(context)!.myActivitiesTitle,
      ),
      BottomNavigationBarItem(
        icon: _iconWithNotification(
            icon: Icon(Icons.chat_bubble),
            notification: notifications.newMessages,
            notificationColor: Theme.of(context).colorScheme.error),
        label: AppLocalizations.of(context)!.chatsTitle,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: AppLocalizations.of(context)!.profileTitle,
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
          // TODO Future whenever I update notificationsDate on firebase in user
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
          // Only for debug
          // Upgrader.clearSavedSettings();
          final androidAppcastURL =
              "https://raw.githubusercontent.com/chrhartm/letss-appcast/main/appcast-android.xml";
          final iOSAppcastURL =
              "https://raw.githubusercontent.com/chrhartm/letss-appcast/main/appcast-ios.xml";
          final cfgAndroid = AppcastConfiguration(
              url: androidAppcastURL, supportedOS: ['android']);
          final cfgiOS =
              AppcastConfiguration(url: iOSAppcastURL, supportedOS: ['ios']);

          Color primaryColor = Theme.of(context).colorScheme.primary;

          return MyScaffold(
            body: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Theme.of(context).colorScheme.onPrimary)),
                child: UpgradeAlert(
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context)
                              .colorScheme
                              .copyWith(primary: primaryColor)),
                      child: nav.content),
                  showIgnore: false,
                  dialogStyle: Platform.isAndroid
                      ? UpgradeDialogStyle.material
                      : UpgradeDialogStyle.cupertino,
                  upgrader: Upgrader(
                      appcastConfig: Platform.isAndroid ? cfgAndroid : cfgiOS,
                      ),
                ),
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
