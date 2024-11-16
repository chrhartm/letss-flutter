import 'package:flutter/material.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/screens/myactivities/widgets/activitylike.dart';
import 'package:letss_app/screens/widgets/other/BasicListTile.dart';
import 'package:letss_app/screens/widgets/other/textdivider.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/participantpreview.dart';
import 'package:provider/provider.dart';

import '../../../models/like.dart';
import '../../../models/person.dart';
import '../../../models/activity.dart';
import '../../../provider/myactivitiesprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LikesTile extends StatelessWidget {
  const LikesTile({super.key, required this.activity});

  final Activity activity;

  Widget _buildLike(Like like, bool interactive, Activity activity) {
    return (Column(children: [
      const SizedBox(height: 2),
      ActivityLike(like: like, activity: activity, interactive: interactive)
    ]));
  }

  Widget _buildAddFollower({required BuildContext context}) {
    return (Column(children: [
      BasicListTile(
        noPadding: true,
        onTap: () {
          Navigator.pushNamed(context, '/myactivities/addfollowers',
              arguments: activity);
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          child: Icon(Icons.people_rounded),
        ),
        title: AppLocalizations.of(context)!.noLikesTitle,
        subtitle: AppLocalizations.of(context)!.noLikesSubtitle,
      ),
    ]));
  }

  Widget _buildParticipant({required Person person}) {
    return (Column(children: [
      const SizedBox(height: 2),
      ParticipantPreview(
        person: person,
        activity: activity,
        removable: true,
      )
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myactivities, child) {
      List<Widget> widgets = [];

      widgets.add(_buildAddFollower(context: context));
      if (activity.participants.isNotEmpty) {
        widgets.add(
            TextDivider(text: AppLocalizations.of(context)!.myActivityJoining));
      }
      activity.participants
          .forEach((p) => widgets.add(_buildParticipant(person: p)));
      widgets.add(StreamBuilder(
          // TODO fix, shouldn't call service directly, shoudl use activity.likes
          stream: ActivityService.streamMyLikes(activity.uid),
          builder: (BuildContext context, AsyncSnapshot<Iterable<Like>> likes) {
            if (likes.hasData && likes.data!.isNotEmpty) {
              bool somebodyJoining = false;
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int i) {
                  if (i == likes.data!.length) {
                    if (somebodyJoining) {
                      return TextDivider(
                          text: AppLocalizations.of(context)!.myActivityLikes);
                    } else {
                      return Container();
                    }
                  } else if (activity
                      .hasParticipant(likes.data!.elementAt(i).person)) {
                    return Container();
                  } else {
                    somebodyJoining = true;
                    return _buildLike(likes.data!.elementAt(i), true, activity);
                  }
                },
                itemCount: likes.data!.length + 1,
                reverse: true,
              );
            } else if (likes.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              return Container();
            }
          }));

      return Container(
          width: double.infinity,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Column(children: widgets)));
    });
  }
}
