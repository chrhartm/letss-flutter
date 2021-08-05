import 'package:flutter/material.dart';
import '../models/activity.dart';
import 'letsstile.dart';
import 'texttile.dart';
import 'tagtile.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
            color: Colors.grey[100],
            child: Column(children: [
              const SizedBox(height: 10),
              LetssTile(activityName: activity.getName()),
              const SizedBox(height: 10),
              TextTile(title: "bio", text: activity.getPerson().getBio()),
              const SizedBox(height: 10),
              TextTile(title: "activity", text: activity.getDescription()),
              const SizedBox(height: 10),
              TagTile(tags: activity.getCategories())
            ])));
  }
}
