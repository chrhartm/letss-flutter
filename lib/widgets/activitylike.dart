import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../screens/likescreen.dart';
import '../models/like.dart';

class ActivityLike extends StatelessWidget {
  const ActivityLike(
      {Key? key,
      required this.like,
      required this.activity,
      this.interactive = true})
      : super(key: key);

  final Like like;
  final Activity activity;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: like.person.thumbnail,
      title:
          Text(like.person.name, style: Theme.of(context).textTheme.headline5),
      subtitle: Text(like.message,
          style: Theme.of(context).textTheme.body2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      onTap: () {
        if (this.interactive) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LikeScreen(activity: this.activity, like: this.like)),
          );
        }
      },
    );
  }
}
