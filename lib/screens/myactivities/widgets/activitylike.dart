import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/buttons/circlebutton.dart';
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
      {super.key,
      required this.like,
      required this.activity,
      this.interactive = true});

  final Like like;
  final Activity activity;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, activities, child) {
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
                  settings:
                      const RouteSettings(name: '/myactivities/likes/like'),
                  builder: (context) =>
                      LikeScreen(activity: activity, like: like)),
            );
          }
        },
        trailing: (interactive)
            ? IntrinsicWidth(
                child: Row(children: [
                CircleButton(
                    icon: Icons.remove,
                    onPressed: () {
                      activities.passLike(like: like);
                    },
                    highlighted: false),
                const SizedBox(width: 10),
                CircleButton(
                    icon: Icons.add,
                    onPressed: () {
                      Provider.of<MyActivitiesProvider>(context, listen: false)
                          .confirmLike(
                              activity: activity,
                              like: like,
                              welcomeMessage: AppLocalizations.of(context)!
                                  .welcomeMessage(like.person.name),
                              context: context);
                      Provider.of<NavigationProvider>(context, listen: false)
                          .navigateTo('/chats');
                    },
                    highlighted: true)
              ]))
            : null,
      );
    });
  }
}
