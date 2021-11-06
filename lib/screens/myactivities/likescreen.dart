import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:provider/provider.dart';

import '../../backend/analyticsservice.dart';
import '../widgets/tiles/textheaderscreen.dart';
import '../../models/activity.dart';
import '../../models/like.dart';
import '../../models/person.dart';
import '../chats/widgets/messagetile.dart';
import '../widgets/tiles/texttile.dart';
import '../widgets/tiles/tagtile.dart';
import '../widgets/tiles/profilepictile.dart';
import '../widgets/tiles/nametile.dart';
import '../../provider/myactivitiesprovider.dart';
import '../widgets/buttons/buttonaction.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({
    Key? key,
    required this.activity,
    required this.like,
  }) : super(key: key);

  final Activity activity;
  final Like like;

  @override
  Widget build(BuildContext context) {
    Person person = like.person;
    return Consumer<MyActivitiesProvider>(
        builder: (context, activities, child) {
      return Scaffold(
          body: SafeArea(
              child: TextHeaderScreen(
                  header: activity.name,
                  back: true,
                  child: ListView(children: [
                    const SizedBox(height: 5),
                    MessageTile(text: like.message, me: false),
                    const SizedBox(height: 5),
                    ProfilePicTile(title: "user picture", person: person),
                    const SizedBox(height: 5),
                    NameTile(person: person),
                    const SizedBox(height: 5),
                    TextTile(title: "bio", text: person.bio),
                    const SizedBox(height: 5),
                    TagTile(
                      tags: person.interests,
                      interests: true,
                    ),
                    FlagTile(
                        flagger:
                            Provider.of<UserProvider>(context, listen: false)
                                .user
                                .person,
                        flagged: activity.person,
                        activity: activity),
                    const SizedBox(height: 150)
                  ]))),
          floatingActionButton: Padding(
            padding: ButtonAction.buttonPaddingNoMenu,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ButtonAction(
                    onPressed: () {
                      analytics.logEvent(name: "Like_Pass");
                      activities.updateLike(
                          activity: activity, like: like, status: 'PASSED');
                      Navigator.pop(context);
                    },
                    icon: Icons.not_interested,
                    hero: null,
                  ),
                  const SizedBox(width: 8),
                  ButtonAction(
                      onPressed: () {
                        analytics.logEvent(name: "Like_Match");
                        activities.updateLike(
                            activity: activity, like: like, status: 'LIKED');
                        Navigator.pop(context);
                      },
                      icon: Icons.chat_bubble,
                      hero: true)
                ]),
          ));
    });
  }
}
