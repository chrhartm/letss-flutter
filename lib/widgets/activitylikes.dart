import 'package:flutter/material.dart';
import '../models/activity.dart';
import 'activitylike.dart';

class ActivityLikes extends StatelessWidget {
  const ActivityLikes({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Align(
        alignment: Alignment.topLeft,
        child:
            Text(activity.name, style: Theme.of(context).textTheme.headline3)));

    for (int i = 0; i < activity.likes.length; i++) {
      widgets.add(const SizedBox(height: 2));
      widgets.add(Divider(color: Colors.grey));
      widgets.add(const SizedBox(height: 2));
      widgets.add(ActivityLike(like: activity.likes[i]));
    }

    return Container(
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(children: widgets)))));
  }
}
