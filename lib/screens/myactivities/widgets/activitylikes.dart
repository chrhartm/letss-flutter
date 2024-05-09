import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/other/BasicListTile.dart';
import 'package:letss_app/screens/widgets/other/textdivider.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';
import 'package:provider/provider.dart';

import '../../../models/like.dart';
import '../../../models/person.dart';
import '../../widgets/tiles/widgets/participantpreview.dart';
import '../activityscreen.dart';
import '../../../models/activity.dart';
import 'activitylike.dart';
import '../../../provider/myactivitiesprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityLikes extends StatelessWidget {
  const ActivityLikes({Key? key, required this.activity}) : super(key: key);

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
          child: Icon(Icons.people_rounded),
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onBackground,
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
      bool collapsed = myactivities.isCollapsed(activity);
      List<Widget> widgets = [];
      widgets.add(Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Underlined(
                        text: activity.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ))),
                onTap: () {
                  if (activity.participants.length > 0) {
                    myactivities
                        .gotoChat(context, activity)
                        .onError((error, stackTrace) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(
                                  name: '/myactivities/activity'),
                              builder: (context) =>
                                  ActivityScreen(activity: activity)));
                    });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: const RouteSettings(
                                name: '/myactivities/activity'),
                            builder: (context) =>
                                ActivityScreen(activity: activity)));
                  }
                },
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              padding: EdgeInsets.only(right: 10),
              constraints: BoxConstraints(),
              icon: Align(
                  alignment: Alignment.centerRight,
                  child: collapsed
                      ? Icon(Icons.keyboard_arrow_down)
                      : Icon(Icons.keyboard_arrow_up)),
              onPressed: () {
                myactivities.collapse(activity);
              },
            )
          ]));

      if (!collapsed) {
        widgets.add(_buildAddFollower(context: context));
        if (activity.participants.length > 0) {
          widgets.add(TextDivider(
              text: AppLocalizations.of(context)!.myActivityJoining));
        }
        activity.participants
            .forEach((p) => widgets.add(_buildParticipant(person: p)));
        widgets.add(StreamBuilder(
            stream: myactivities.likeStream(activity),
            builder:
                (BuildContext context, AsyncSnapshot<Iterable<Like>> likes) {
              if (likes.hasData && likes.data!.length > 0) {
                bool somebodyJoining = false;
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int i) {
                    if (i == likes.data!.length) {
                      if (somebodyJoining) {
                        return TextDivider(
                            text:
                                AppLocalizations.of(context)!.myActivityLikes);
                      } else {
                        return Container();
                      }
                    } else if (activity
                        .hasParticipant(likes.data!.elementAt(i).person)) {
                      return Container();
                    } else {
                      somebodyJoining = true;
                      return _buildLike(
                          likes.data!.elementAt(i), true, activity);
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
      }

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
