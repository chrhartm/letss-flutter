import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:provider/provider.dart';
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
                    TextTile(title: "activity", text: activity.description),
                    const SizedBox(height: 5),
                    TagTile(tags: activity.categories),
                    const SizedBox(height: 5),
                    TextTile(title: "bio", text: person.bio),
                    const SizedBox(height: 150)
                  ]))),
          floatingActionButton: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    analytics.logEvent(name: "Like_Pass");
                    activities.updateLike(
                        activity: activity, like: like, status: 'PASSED');
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.not_interested,
                    color: Colors.white,
                  ),
                  heroTag: null,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                    onPressed: () {
                      analytics.logEvent(name: "Like_Match");
                      activities.updateLike(
                          activity: activity, like: like, status: 'LIKED');
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.chat_bubble,
                      color: Colors.white,
                    ))
              ]));
    });
  }
}
