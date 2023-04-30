import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/myactivities/activityscreen.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';

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
      title: Underlined(
          text: activity.name,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.bold),
          maxlines: 1,
          overflow: TextOverflow.ellipsis),
      subtitle: activity.hasDescription
          ? Text(activity.description!,
              style: Theme.of(context).textTheme.bodyMedium!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
    );
  }
}
