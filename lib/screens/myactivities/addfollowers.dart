import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/widgets/buttons/circlebutton.dart';
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
  const AddFollowers({super.key});
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
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          child:
              Icon(!kIsWeb && Platform.isIOS ? Icons.ios_share : Icons.share),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.photo),
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
              ? CircleButton(
                  onPressed: () {
                    myactivities.removeParticipant(
                        activity: activity, person: follower.person);
                  },
                  icon: Icons.remove)
              : CircleButton(
                  onPressed: () {
                    myactivities.addParticipant(
                        activity: activity,
                        person: follower.person,
                        welcomeMessage: AppLocalizations.of(context)!
                            .welcomeMessage(follower.person.name));
                  },
                  icon: Icons.add,
                  highlighted: false))
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
        List<Follower> followers = followerProvider.followers;
        return MyScaffold(
            body: HeaderScreen(
                title: AppLocalizations.of(context)!.addFollowersTitle,
                subtitle: activity.name,
                back: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _buildShareActivity(
                          context: context, activity: activity);
                    } else if (index == followers.length + 1) {
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
                          follower: followers.elementAt(index - 1),
                          clickable: true);
                    }
                  },
                  itemCount: followers.length + 2,
                  reverse: false,
                )));
      });
    });
  }
}
