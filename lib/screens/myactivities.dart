import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/analyticsservice.dart';
import '../models/activity.dart';
import '../provider/myactivitiesprovider.dart';
import '../widgets/activitylikes.dart';
import '../widgets/textheaderscreen.dart';
import '../widgets/buttonaction.dart';

class MyActivities extends StatelessWidget {
  List<Widget> _createMyActivities(List<Activity> myActivities) {
    List<Widget> widgets = [];

    for (int i = 0; i < myActivities.length; i++) {
      if (myActivities[i].status == 'ACTIVE') {
        widgets.add(ActivityLikes(activity: myActivities[i]));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return Scaffold(
          body: TextHeaderScreen(
              header: "My Activities",
              child: ListView(
                  children: _createMyActivities(myActivities.myActivities))),
          floatingActionButton: Padding(
              padding: ButtonAction.buttonPadding,
              child: ButtonAction(
                  onPressed: () {
                    myActivities.editActiviyUid = null;
                    analytics.logEvent(name: "Activity_Add");
                    Navigator.pushNamed(
                        context, '/myactivities/activity/editname');
                  },
                  icon: Icons.add,
                  hero: true)));
    });
  }
}
