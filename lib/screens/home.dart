import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
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
  const Home({this.start = '/activities', super.key});

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
        icon: _iconWithNotification(
            icon: Icon(Icons.people),
            notification: notifications.newLikes,
            notificationColor: Theme.of(context).colorScheme.error),
        label: AppLocalizations.of(context)!.activitiesTitle,
      ),
    ];
    options.addAll([
      BottomNavigationBarItem(
        icon: Icon(Icons.lightbulb),
        label: AppLocalizations.of(context)!.templateSearchHeader,
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: AppLocalizations.of(context)!.signupExplainerAddTitle),
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
          if (!kIsWeb &&
              user.user.requestedSupport == false &&
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
          if (!kIsWeb && user.user.requestedNotifications == false) {
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

          Color primaryColor = Theme.of(context).colorScheme.primary;

          return MyScaffold(
            body: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Theme.of(context).colorScheme.onPrimary)),
                child: UpgradeAlert(
                  showIgnore: false,
                  dialogStyle: kIsWeb || Platform.isAndroid
                      ? UpgradeDialogStyle.material
                      : UpgradeDialogStyle.cupertino,
                  upgrader: Upgrader(
                    storeController: UpgraderStoreController(
                      onAndroid: () =>
                          UpgraderAppcastStore(appcastURL: androidAppcastURL),
                      oniOS: () =>
                          UpgraderAppcastStore(appcastURL: iOSAppcastURL),
                    ),
                  ),
                  child: Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context)
                              .colorScheme
                              .copyWith(primary: primaryColor)),
                      child: nav.content),
                ),
              ),
            ),
            bottomNavigationBar: kIsWeb
                ? null
                : BottomNavigationBar(
                    items: _buildOptions(notifications, user, nav, context),
                    // Hack to allow add activity button
                    currentIndex: nav.index >= 2 ? nav.index + 1 : nav.index,
                    backgroundColor: Colors.grey[100],
                    selectedItemColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: (index) {
                      if (index < 2) {
                        nav.index = index;
                        notifications.activeTab = nav.activeTab;
                      }
                      if (index == 2) {
                        Provider.of<MyActivitiesProvider>(context,
                                listen: false)
                            .addNewActivity(context);
                      }
                      if (index > 2) {
                        nav.index = index - 1;
                        notifications.activeTab = nav.activeTab;
                      }
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
