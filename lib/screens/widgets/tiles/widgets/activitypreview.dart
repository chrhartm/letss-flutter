import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/myactivities/activityscreen.dart';

class ActivityPreview extends StatelessWidget {
  const ActivityPreview({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                settings:
                    const RouteSettings(name: '/chats/chat/profile/activity'),
                builder: (context) => ActivityScreen(
                      activity: activity,
                      mine: false,
                    )));
      },
      contentPadding: EdgeInsets.zero,
      title: Text(activity.name,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: Text(activity.description,
          style: Theme.of(context).textTheme.bodyText2!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
