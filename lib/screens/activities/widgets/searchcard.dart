import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/activities/widgets/activityswipecard.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';

class SearchCard extends StatelessWidget {
  final Activity activity;

  const SearchCard(
    this.activity, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: ActivitySwipeCard(activity: activity, back: true),
    );
  }
}
