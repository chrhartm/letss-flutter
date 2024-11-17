import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/other/basiclisttile.dart';

import '../../../models/follower.dart';

class FollowPreview extends StatelessWidget {
  const FollowPreview(
      {super.key,
      required this.follower,
      required this.following,
      required this.clickable,
      this.trailing});

  final Follower follower;
  final bool following;
  final bool clickable;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return BasicListTile(
      onTap: () {
        if (clickable) {
          Navigator.pushNamed(context, "/profile/person",
              arguments: follower.person);
        }
      },
      primary: true,
      leading: follower.person.thumbnail,
      title: follower.person.name + follower.person.supporterBadge,
      subtitle: follower.person.job,
      trailing: trailing,
      noPadding: true,
    );
  }
}
