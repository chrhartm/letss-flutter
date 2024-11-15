import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../provider/myactivitiesprovider.dart';
import '../activities/widgets/activitycard.dart';

class ActivityScreen extends StatelessWidget {
  final Activity activity;

  const ActivityScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return MyScaffold(
          body: Scaffold(
        body: ActivityCard(activity: activity, back: true),
      ));
    });
  }
}
