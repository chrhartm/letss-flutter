import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/activities/widgets/searchcard.dart';
import 'package:letss_app/screens/myactivities/activityscreen.dart';
import 'package:letss_app/screens/widgets/other/basiclisttile.dart';

class ActivityPreview extends StatelessWidget {
  const ActivityPreview({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return BasicListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              settings:
                  const RouteSettings(name: '/chats/chat/profile/activity'),
              builder: (context) =>
                  activity.person.uid == FirebaseAuth.instance.currentUser!.uid
                      ? ActivityScreen(activity: activity, mine: true)
                      : SearchCard(activity),
            ));
      },
      noPadding: true,
      title: activity.name,
      primary: true,
      leading: activity.person.thumbnail,
      underlined: false,
      threeLines: false,
      subtitle: activity.hasDescription
          ? activity.description
          : activity.categories?.join(", "),
    );
  }
}
