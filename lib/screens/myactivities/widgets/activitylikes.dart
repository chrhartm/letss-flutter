import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/like.dart';
import '../activityscreen.dart';
import '../../../models/activity.dart';
import 'activitylike.dart';
import '../../../provider/myactivitiesprovider.dart';

class ActivityLikes extends StatelessWidget {
  const ActivityLikes({Key? key, required this.index}) : super(key: key);

  final int index;

  Widget _buildLike(Like like, bool interactive, Activity activity) {
    return (Column(children: [
      const SizedBox(height: 2),
      Divider(),
      const SizedBox(height: 2),
      ActivityLike(like: like, activity: activity, interactive: interactive)
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myactivities, child) {
      Activity activity = myactivities.myActivities[index];
      bool collapsed = myactivities.collapsed[index];
      List<Widget> widgets = [];
      widgets.add(Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(activity.name,
                      style: Theme.of(context).textTheme.headline2)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings:
                            const RouteSettings(name: '/myactivities/activity'),
                        builder: (context) =>
                            ActivityScreen(activity: activity)));
              },
            ),
            GestureDetector(
              child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: collapsed
                          ? Icon(Icons.keyboard_arrow_left)
                          : Icon(Icons.keyboard_arrow_down))),
              onTap: () {
                myactivities.collapse(index);
              },
            )
          ]));

      if (!collapsed) {
        widgets.add(StreamBuilder(
            stream: myactivities.likeStream(activity),
            builder:
                (BuildContext context, AsyncSnapshot<Iterable<Like>> likes) {
              if (likes.hasData && likes.data!.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int i) =>
                      _buildLike(likes.data!.elementAt(i), true, activity),
                  itemCount: likes.data!.length,
                  reverse: true,
                );
              } else if (likes.connectionState == ConnectionState.waiting) {
                return _buildLike(Like.empty(), false, activity);
              } else {
                return _buildLike(Like.noLike(), false, activity);
              }
            }));
      }

      return Container(
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(children: widgets)))));
    });
  }
}
