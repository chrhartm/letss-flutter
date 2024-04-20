import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../provider/myactivitiesprovider.dart';
import 'widgets/activitylikes.dart';
import '../widgets/buttons/buttonaction.dart';
import 'widgets/noactivities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          body: HeaderScreen(
              title: AppLocalizations.of(context)!.myActivitiesTitle,
              child: ListView(
                  children: _createMyActivities(myActivities.myActivities))),
          floatingActionButton: Padding(
              padding: ButtonAction.buttonPadding,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonAction(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/myactivities/templates");
                            },
                            icon: Icons.lightbulb,
                            heroTag: null),
                      ]))));
    });
  }
}
