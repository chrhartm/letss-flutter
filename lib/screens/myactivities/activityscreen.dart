import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:letss_app/screens/myactivities/widgets/archiveactivitydialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../backend/analyticsservice.dart';
import '../../backend/linkservice.dart';
import '../../models/activity.dart';
import '../../provider/myactivitiesprovider.dart';
import '../activities/widgets/activitycard.dart';
import '../widgets/buttons/buttonaction.dart';
import '../widgets/other/loader.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key, required this.activity, this.mine = true})
      : super(key: key);

  final Activity activity;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return Scaffold(
          body: SafeArea(
              child: LoaderOverlay(
                                    useDefaultLoading: false,
                                    overlayWidget: Center(
                                      child: Loader(),
                                    ),
                                    overlayOpacity: 0.6,
                                    child: Scaffold(
                  body: ActivityCard(activity: activity, back: true),
                  floatingActionButton: !mine
                      ? null
                      : Padding(
                          padding: ButtonAction.buttonPaddingNoMenu,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonAction(
                                        onPressed: () {
                                          analytics.logEvent(
                                              name: "MyActivity_Share");
                                          context.loaderOverlay.show();
                                          LinkService.shareActivity(
                                                  activity: activity,
                                                  mine: true)
                                              .then((_) =>
                                                  context.loaderOverlay.hide());
                                        },
                                        icon: Platform.isIOS
                                            ? Icons.ios_share
                                            : Icons.share),
                                const SizedBox(height: ButtonAction.buttonGap),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ButtonAction(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ArchiveChatDialog(
                                                    activity: activity);
                                              });
                                        },
                                        icon: Icons.archive,
                                      ),
                                      const SizedBox(
                                          width: ButtonAction.buttonGap),
                                      ButtonAction(
                                          onPressed: () {
                                            myActivities.editActiviyUid =
                                                activity.uid;
                                            analytics.logEvent(
                                                name: "MyActivity_Edit");
                                            Navigator.pushNamed(context,
                                                '/myactivities/activity/editname');
                                          },
                                          icon: Icons.edit,
                                          heroTag: "editActivity")
                                    ])
                              ],
                            ),
                          ))))));
    });
  }
}
