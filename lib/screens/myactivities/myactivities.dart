import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../provider/myactivitiesprovider.dart';
import 'widgets/activitylikes.dart';
import '../widgets/tiles/textheaderscreen.dart';
import '../widgets/buttons/buttonaction.dart';
import 'widgets/noactivities.dart';

class MyActivities extends StatelessWidget {
  List<Widget> _createMyActivities(
      UnmodifiableListView<Activity> myActivities) {
    List<Widget> widgets = [];

    for (int i = 0; i < myActivities.length; i++) {
      if (myActivities[i].status == 'ACTIVE') {
        widgets.add(ActivityLikes(activity: myActivities[i]));
      }
    }

    if (widgets.length == 0) {
      widgets.add(NoActivities());
    }

    // To not have expand button under add button
    widgets.add(const SizedBox(height: 20));

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
                    myActivities.addNewActivity(context);
                  },
                  icon: Icons.add,
                  heroTag: "add")));
    });
  }
}
