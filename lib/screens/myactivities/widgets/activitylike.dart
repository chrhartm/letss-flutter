import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/other/BasicListTile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    String name = like.person.name + like.person.supporterBadge;
    return BasicListTile(
      noPadding: true,
      leading: like.person.thumbnail,
      title: name,
      subtitle: like.hasMessage ? like.message! : like.person.job,
      boldSubtitle: !like.read,
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
                    .confirmLike(
                        activity: activity,
                        like: like,
                        welcomeMessage: AppLocalizations.of(context)!
                            .welcomeMessage(like.person.name));
                Provider.of<NavigationProvider>(context, listen: false)
                    .navigateTo('/chats');
              },
              icon: Icon(Icons.add))
          : null,
    );
  }
}
