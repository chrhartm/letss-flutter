import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:provider/provider.dart';

import '../../../models/activity.dart';
import '../../../provider/navigationprovider.dart';
import '../likescreen.dart';
import '../../../models/like.dart';
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
    bool interactive = (like.person.uid != "" && this.interactive);
    TextStyle readstyle = Theme.of(context).textTheme.bodyMedium!;
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);
    List<Widget> name = [
      Text(like.person.name + like.person.supporterBadge,
          style: Theme.of(context).textTheme.headlineSmall)
    ];
    return ListTile(
      leading: like.person.thumbnail,
      title: Row(
        children: name,
      ),
      subtitle: Text(like.hasMessage ? like.message! : like.person.job,
          style: like.read ? readstyle : unreadstyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      onTap: () {
        if (interactive) {
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
      trailing: (interactive)
          ? IconButton(
              onPressed: () {
                Provider.of<MyActivitiesProvider>(context, listen: false)
                    .confirmLike(activity: activity, like: like);
                Provider.of<NavigationProvider>(context, listen: false)
                    .navigateTo('/chats');
              },
              icon: Icon(Icons.add))
          : null,
    );
  }
}
