import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:provider/provider.dart';

import '../../models/follower.dart';
import '../../models/person.dart';
import '../../provider/followerprovider.dart';
import '../../provider/myactivitiesprovider.dart';
import '../profile/widgets/followpreview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFollowers extends StatelessWidget {
  const AddFollowers({Key? key}) : super(key: key);

  Widget _buildFollower(
      {required BuildContext context,
      required Follower follower,
      required Activity activity,
      required MyActivitiesProvider myactivities,
      required bool clickable}) {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 2));
    widgets.add(Divider());
    widgets.add(const SizedBox(height: 2));
    widgets.add(FollowPreview(
      follower: follower,
      following: true,
      clickable: clickable,
      trailing: clickable
          ? (activity.hasParticipant(follower.person)
              ? IconButton(onPressed: () {}, icon: Icon(Icons.horizontal_rule))
              : IconButton(
                  onPressed: () {
                    myactivities.addParticipant(
                        activity: activity, person: follower.person);
                  },
                  icon: Icon(Icons.add),
                ))
          : null,
    ));

    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    Activity activity = ModalRoute.of(context)!.settings.arguments as Activity;

    return Consumer<FollowerProvider>(
        builder: (context, followerProvider, child) {
      return Consumer<MyActivitiesProvider>(
          builder: (context, myactivities, child) {
        return MyScaffold(
                body: SubtitleHeaderScreen(
          title: AppLocalizations.of(context)!.addFollowersTitle,
          subtitle: "${activity.name}",
          back: true,
          child: StreamBuilder(
              stream: followerProvider.followingStream,
              builder: (BuildContext context,
                  AsyncSnapshot<Iterable<Follower>> followers) {
                if (followers.hasData && followers.data!.length > 0) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) =>
                        _buildFollower(
                            context: context,
                            activity: activity,
                            myactivities: myactivities,
                            follower: followers.data!.elementAt(index),
                            clickable: true),
                    itemCount: followers.data!.length,
                    reverse: false,
                  );
                } else if (followers.connectionState ==
                    ConnectionState.waiting) {
                  return Container();
                } else {
                  return _buildFollower(
                      context: context,
                      activity: activity,
                      myactivities: myactivities,
                      follower: Follower(
                          person: Person.emptyPerson(
                              name: (AppLocalizations.of(context)!
                                  .addFollowersNoFollowersTitle),
                              job: (AppLocalizations.of(context)!
                                  .addFollowersNoFollowersAction)),
                          dateAdded: DateTime.now(),
                          following: true),
                      clickable: false);
                }
              }),
        ));
      });
    });
  }
}
