import 'dart:io';

import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:letss_app/screens/widgets/tiles/activitystatustile.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import '../../../models/person.dart';
import '../../widgets/tiles/participantstile.dart';
import '../../widgets/tiles/texttile.dart';
import '../../widgets/tiles/tagtile.dart';
import '../../widgets/tiles/profilepictile.dart';
import '../../widgets/tiles/nametile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    this.back = false,
  }) : super(key: key);

  final Activity activity;
  final bool back;

  List<Widget> buildList(Person userPerson, BuildContext context) {
    Person person = activity.person;

    List<Widget> widgets = [
      const SizedBox(height: 0),
      ProfilePicTile(
          title: AppLocalizations.of(context)!.tileProfilePic, person: person),
      const SizedBox(height: 0),
      NameTile(
        person: person,
        padding: false,
        otherLocation: userPerson.location,
      ),
      // const SizedBox(height: 0),
      // ActionsTile(
      //   person: person,
      // ),
      const SizedBox(height: 10),
    ];

    widgets.add(AcitivityStatusTile(activity: activity));

    if (activity.hasParticipants) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(ParticipantsTile(activity: activity));
    }
    if (activity.hasDescription) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TextTile(
          title: AppLocalizations.of(context)!.tileActivity,
          text: activity.description!));
    }
    if (activity.hasCategories) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TagTile(
        tags: activity.categories!,
        otherTags: userPerson.hasInterests ? userPerson.interests! : [],
      ));
    }
    if (person.hasBio) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TextTile(
          title: AppLocalizations.of(context)!.tileBio, text: person.bio!));
    }
    if (userPerson.uid != activity.person.uid) {
      widgets.add(FlagTile(
          flagger: userPerson, flagged: activity.person, activity: activity));
    } else {
      widgets.add(TextTile(
          text: activity.locationString,
          title: AppLocalizations.of(context)!.tileActivityLocation));
    }

    widgets.add(const SizedBox(height: 150));
    return widgets;
  }

  Widget _buildShareButton(BuildContext context, UserProvider user) {
    return GestureDetector(
      child: Icon(Platform.isIOS ? Icons.ios_share : Icons.share,
          color: Theme.of(context).colorScheme.onBackground),
      onTap: () {
        context.loaderOverlay.show();
        LinkService.shareActivity(
                activity: activity,
                mine: activity.person.uid == user.user.person.uid)
            .then(((_) => context.loaderOverlay.hide()))
            .onError((error, stackTrace) =>
                (error, stackTrace) => context.loaderOverlay.hide());
        ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return HeaderScreen(
        title: activity.name,
        back: back,
        underlined: true,
        trailing: _buildShareButton(context, user),
        child: Column(
          children: buildList(user.user.person, context),
        ),
      );
    });
  }
}
