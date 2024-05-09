import 'dart:io';

import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/other/basiclisttile.dart';
import 'package:letss_app/screens/widgets/other/textdivider.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../models/follower.dart';
import '../../models/person.dart';
import '../../provider/followerprovider.dart';
import '../../provider/myactivitiesprovider.dart';
import '../profile/widgets/followpreview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFollowers extends StatelessWidget {
  const AddFollowers({Key? key}) : super(key: key);

  Widget _buildShareActivity(
      {required BuildContext context, required Activity activity}) {
    List<Widget> widgets = [];
    widgets.add(
      BasicListTile(
        noPadding: true,
        onTap: () {
          context.loaderOverlay.show();
          Provider.of<ActivitiesProvider>(context, listen: false)
              .share(activity)
              .then(((_) => context.loaderOverlay.hide()))
              .onError((error, stackTrace) =>
                  (error, stackTrace) => context.loaderOverlay.hide());
        },
        leading: CircleAvatar(
          child: Icon(Platform.isIOS ? Icons.ios_share : Icons.share),
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        primary: true,
        title: AppLocalizations.of(context)!.addFollowersShareTitle,
        subtitle: AppLocalizations.of(context)!.addFollowersShareSubtitle,
      ),
    );
    // Download social media image
    widgets.add(BasicListTile(
      noPadding: true,
      onTap: () {
        context.loaderOverlay.show();
        Provider.of<ActivitiesProvider>(context, listen: false)
            .downloadAndShareImage(activity)
            .then(((_) => context.loaderOverlay.hide()))
            .onError((error, stackTrace) =>
                (error, stackTrace) => context.loaderOverlay.hide());
      },
      leading: CircleAvatar(
        child: Icon(Icons.photo),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      primary: true,
      title: AppLocalizations.of(context)!.addFollowersDownloadTitle,
      subtitle: AppLocalizations.of(context)!.addFollowersDownloadSubtitle,
    ));
    widgets.add(SizedBox(height: 20));
    widgets.add(
        TextDivider(text: AppLocalizations.of(context)!.addFollowersDivider));
    widgets.add(SizedBox(height: 10));

    return Column(children: widgets);
  }

  Widget _buildFollower(
      {required BuildContext context,
      required Follower follower,
      required Activity activity,
      required MyActivitiesProvider myactivities,
      required bool clickable}) {
    List<Widget> widgets = [];

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
    widgets
        .add(Divider(color: Theme.of(context).colorScheme.primary, height: 5));

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
            body: HeaderScreen(
          title: AppLocalizations.of(context)!.addFollowersTitle,
          subtitle: "${activity.name}",
          back: true,
          child: StreamBuilder(
              stream: followerProvider.followingStream,
              builder: (BuildContext context,
                  AsyncSnapshot<Iterable<Follower>> followers) {
                if (followers.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _buildShareActivity(
                            context: context, activity: activity);
                      } else if (index == followers.data!.length + 1) {
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
                      } else {
                        return _buildFollower(
                            context: context,
                            activity: activity,
                            myactivities: myactivities,
                            follower: followers.data!.elementAt(index - 1),
                            clickable: true);
                      }
                    },
                    itemCount: followers.data!.length + 2,
                    reverse: false,
                  );
                } else if (followers.connectionState ==
                    ConnectionState.waiting) {
                  return Container();
                } else {
                  return Container();
                }
              }),
        ));
      });
    });
  }
}
