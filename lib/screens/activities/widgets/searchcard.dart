import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/activities/widgets/activityswipecard.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';

class SearchCard extends StatelessWidget {
  const SearchCard(
    Activity activity, {
    Key? key,
  })  : this.activity = activity,
        super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: ActivitySwipeCard(activity: activity, back: true),
    );
  }
}
