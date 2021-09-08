import 'package:flutter/material.dart';
import '../screens/activityscreen.dart';
import '../models/activity.dart';
import 'activitylike.dart';

class ActivityLikes extends StatelessWidget {
  const ActivityLikes({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(GestureDetector(
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(activity.name,
              style: Theme.of(context).textTheme.headline3)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivityScreen(activity: activity)));
      },
    ));

    for (int i = 0; i < activity.likes.length; i++) {
      if (activity.likes[i].status == 'ACTIVE') {
        widgets.add(const SizedBox(height: 2));
        widgets.add(Divider(color: Colors.grey));
        widgets.add(const SizedBox(height: 2));
        widgets.add(
            ActivityLike(like: activity.likes[i], activity: this.activity));
      }
    }

    return Container(
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.only(top: 0),
            child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(children: widgets)))));
  }
}
