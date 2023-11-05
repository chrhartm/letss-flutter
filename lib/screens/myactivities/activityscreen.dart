
import 'package:flutter/material.dart';
import 'package:letss_app/screens/myactivities/widgets/archiveactivitydialog.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../provider/myactivitiesprovider.dart';
import '../../provider/userprovider.dart';
import '../activities/widgets/activitycard.dart';
import '../activities/widgets/likedialog.dart';
import '../activities/widgets/nocoinsdialog.dart';
import '../widgets/buttons/buttonaction.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key, required this.activity, this.mine = true})
      : super(key: key);

  final Activity activity;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    int coins = Provider.of<UserProvider>(context, listen: false).user.coins;
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return MyScaffold(
          body: Scaffold(
              body: ActivityCard(activity: activity, back: true),
              floatingActionButton: !mine
                  ? Padding(
                      padding: ButtonAction.buttonPaddingNoMenu,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: ButtonAction(
                            onPressed: () {
                              if (coins > 0) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LikeDialog(
                                          activity: activity, controller: null);
                                    });
                              } else {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return FractionallySizedBox(
                                          heightFactor: 0.3,
                                          child: NoCoinsDialog());
                                    });
                              }
                            },
                            icon: Icons.add,
                            heroTag: "like_${activity.uid}",
                            coins: coins,
                          )))
                  : activity.isArchived
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
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ArchiveActivityDialog(
                                                  activity: activity);
                                            });
                                      },
                                      icon: Icons.archive,
                                    ),
                                    const SizedBox(
                                        height: ButtonAction.buttonGap),
                                    ButtonAction(
                                        onPressed: () {
                                          myActivities.editActiviyUid =
                                              activity.uid;
                                          Navigator.pushNamed(context,
                                              '/myactivities/activity/editname');
                                        },
                                        icon: Icons.edit,
                                        heroTag: "editActivity"),
                                  ])),
                        )));
    });
  }
}
