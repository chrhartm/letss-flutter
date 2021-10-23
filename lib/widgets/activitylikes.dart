import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/like.dart';
import '../screens/activityscreen.dart';
import '../models/activity.dart';
import 'activitylike.dart';
import '../provider/myactivitiesprovider.dart';
import '../backend/loggerservice.dart';

class ActivityLikes extends StatelessWidget {
  const ActivityLikes({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  Widget _buildLike(Like like, bool interactive) {
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
      List<Widget> widgets = [];
      widgets.add(GestureDetector(
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(activity.name,
                style: Theme.of(context).textTheme.headline2)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: '/myactivities/activity'),
                  builder: (context) => ActivityScreen(activity: activity)));
        },
      ));

      widgets.add(StreamBuilder(
          stream: myactivities.likeStream(activity),
          builder: (BuildContext context, AsyncSnapshot<Iterable<Like>> likes) {
            if (likes.hasData && likes.data!.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) =>
                    _buildLike(likes.data!.elementAt(index), true),
                itemCount: likes.data!.length,
                reverse: true,
              );
            } else if (likes.connectionState == ConnectionState.waiting) {
              return _buildLike(Like.empty(), false);
            } else {
              return _buildLike(Like.noLike(), false);
            }
          }));

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
