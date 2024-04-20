import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:provider/provider.dart';

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
      return MyScaffold(
          body: Scaffold(
              body: ActivityCard(activity: activity, back: true),
              floatingActionButton: !mine
                  ? null
                  : activity.isArchived
                      ? null
                      : Padding(
                          padding: ButtonAction.buttonPaddingNoMenu,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: ButtonAction(
                                onPressed: () {
                                  myActivities.editActiviyUid = activity.uid;
                                  Navigator.pushNamed(context,
                                      '/myactivities/activity/editname');
                                },
                                icon: Icons.edit,
                                heroTag: "editActivity"),
                          ),
                        )));
    });
  }
}
