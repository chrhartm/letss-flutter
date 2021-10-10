import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/analyticsservice.dart';
import '../models/activity.dart';
import '../provider/myactivitiesprovider.dart';
import '../widgets/activitycard.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return Scaffold(
          body: SafeArea(
              child: Scaffold(
                  body: ActivityCard(activity: activity, back: true),
                  floatingActionButton: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                analytics.logEvent(name: "MyActivity_Share");
                              },
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.grey,
                              heroTag: null,
                            ),
                            const SizedBox(height: 8),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FloatingActionButton(
                                    onPressed: () {
                                      myActivities.editActiviyUid =
                                          activity.uid;
                                      analytics.logEvent(
                                          name: "MyActivity_Archive");
                                      myActivities.updateActivity(
                                          status: 'ARCHIVED');
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.archive,
                                      color: Colors.white,
                                    ),
                                    heroTag: null,
                                    backgroundColor: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  FloatingActionButton(
                                    onPressed: () {
                                      myActivities.editActiviyUid =
                                          activity.uid;
                                      analytics.logEvent(
                                          name: "MyActivity_Edit");
                                      Navigator.pushNamed(context,
                                          '/myactivities/activity/editname');
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  )
                                ])
                          ],
                        ),
                      )))));
    });
  }
}
