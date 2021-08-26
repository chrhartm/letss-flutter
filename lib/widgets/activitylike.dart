import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../screens/likescreen.dart';
import '../models/like.dart';

class ActivityLike extends StatelessWidget {
  const ActivityLike({Key? key, required this.like, required this.activity})
      : super(key: key);

  final Like like;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LikeScreen(activity: this.activity, like: this.like)));
        },
        // TODO use ListTile with CircleAvatar
        child: Row(children: [
          SizedBox(width: 50, height: 50, child: like.person.profilePic),
          const SizedBox(width: 5),
          Expanded(
              child: Column(children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                    like.person.name + ", " + like.person.age.toString(),
                    style: Theme.of(context).textTheme.headline5)),
            Align(
                alignment: Alignment.topLeft,
                child: Text(like.message,
                    style: Theme.of(context).textTheme.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis))
          ]))
        ]));
  }
}
