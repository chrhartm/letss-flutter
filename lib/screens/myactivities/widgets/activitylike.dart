import 'package:flutter/material.dart';

import '../../../models/activity.dart';
import '../../activities/likescreen.dart';
import '../../../models/like.dart';
import '../../widgets/other/supporterbadge.dart';
import '../../../backend/activityservice.dart';

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
    TextStyle readstyle = Theme.of(context).textTheme.bodyText2!;
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);
    List<Widget> name = [
      Text(like.person.name, style: Theme.of(context).textTheme.headline5)
    ];
    if (like.person.supporter) {
      name.add(SupporterBadge());
    }
    return ListTile(
      leading: like.person.thumbnail,
      title: Row(
        children: name,
      ),
      subtitle: Text(like.message,
          style: like.read ? readstyle : unreadstyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      onTap: () {
        if (this.interactive) {
          ActivityService.markLikeRead(like);
          Navigator.push(
            context,
            MaterialPageRoute(
                settings: const RouteSettings(name: '/myactivities/likes/like'),
                builder: (context) =>
                    LikeScreen(activity: this.activity, like: this.like)),
          );
        }
      },
    );
  }
}
