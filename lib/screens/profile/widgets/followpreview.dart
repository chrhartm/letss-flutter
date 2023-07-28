import 'package:flutter/material.dart';

import '../../../models/follower.dart';

class FollowPreview extends StatelessWidget {
  const FollowPreview(
      {Key? key,
      required this.follower,
      required this.following,
      required this.clickable,
      this.trailing})
      : super(key: key);

  final Follower follower;
  final bool following;
  final bool clickable;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    Widget name = Text(
      follower.person.name + follower.person.supporterBadge,
      style: Theme.of(context)
          .textTheme
          .headlineSmall!
          .copyWith(fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return ListTile(
      onTap: () {
        if (clickable) {
          Navigator.pushNamed(context, "/profile/person",
              arguments: this.follower.person);
        }
      },
      leading: follower.person.thumbnail,
      title: name,
      subtitle: Text(follower.person.job,
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: trailing,
    );
  }
}
