import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/analyticsservice.dart';
import '../widgets/textheaderscreen.dart';
import '../models/activity.dart';
import '../models/like.dart';
import '../models/person.dart';
import '../widgets/messagetile.dart';
import '../widgets/texttile.dart';
import '../widgets/tagtile.dart';
import '../widgets/imagetile.dart';
import '../widgets/nametile.dart';
import '../provider/myactivitiesprovider.dart';
import '../widgets/buttonaction.dart';

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
                    ImageTile(title: "user picture", image: person.profilePic),
                    const SizedBox(height: 5),
                    NameTile(
                        age: person.age,
                        name: person.name,
                        job: person.job,
                        location: person.locationString),
                    const SizedBox(height: 5),
                    TextTile(title: "bio", text: person.bio),
                    const SizedBox(height: 5),
                    TagTile(tags: person.interests),
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
