import 'package:flutter/material.dart';
import 'package:letss_app/screens/myactivities/widgets/archiveactivitydialog.dart';
import 'package:provider/provider.dart';

import '../../backend/analyticsservice.dart';
import '../../backend/linkservice.dart';
import '../../models/activity.dart';
import '../../provider/myactivitiesprovider.dart';
import '../activities/widgets/activitycard.dart';
import '../widgets/buttons/buttonaction.dart';

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
                                    LinkService.shareActivity(
                                        activity: activity, mine: true);
                                  },
                                  icon: Icons.share,
                                  hero: null,
                                ),
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
                                        hero: null,
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
                                          hero: true)
                                    ])
                              ],
                            ),
                          )))));
    });
  }
}
