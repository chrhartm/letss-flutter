import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/activities/widgets/searchcard.dart';
import 'package:letss_app/screens/widgets/other/basiclisttile.dart';
import 'package:letss_app/screens/widgets/other/counter.dart';

class ActivityPreview extends StatelessWidget {
  final Activity activity;

  const ActivityPreview({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return BasicListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              settings:
                  const RouteSettings(name: '/chats/chat/profile/activity'),
              builder: (context) => SearchCard(activity),
            ));
      },
      noPadding: true,
      title: activity.name,
      primary: true,
      leading: activity.thumbnail,
      underlined: false,
      threeLines: false,
      subtitle: activity.hasDescription
          ? activity.description
          : activity.categories?.join(", "),
      trailing: activity.likeCount > 0
          ? Counter(
              count: activity.likeCount,
            )
          : null,
    );
  }
}
