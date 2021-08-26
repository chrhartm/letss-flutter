import 'package:flutter/material.dart';
import '../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/person.dart';
import 'letsstile.dart';
import 'texttile.dart';
import 'tagtile.dart';
import 'imagetile.dart';
import 'nametile.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    required this.like,
  }) : super(key: key);

  final Activity activity;
  final Function like;

  @override
  Widget build(BuildContext context) {
    Person person = activity.person;
    return Consumer<UserProvider>(builder: (context, user, child) {
      // TODO use Stack to have multiple buttons
      return Padding(
          padding: EdgeInsets.all(0.0),
          child: Scaffold(
              body: Card(
                  color: Colors.white,
                  child: ListView(children: [
                    const SizedBox(height: 0),
                    LetssTile(activityName: activity.name),
                    const SizedBox(height: 0),
                    ImageTile(title: "user picture", image: person.profilePic),
                    const SizedBox(height: 0),
                    NameTile(
                        age: person.age,
                        name: person.name,
                        job: person.job,
                        location: person.location),
                    const SizedBox(height: 0),
                    TextTile(title: "activity", text: activity.description),
                    const SizedBox(height: 0),
                    TagTile(
                      tags: activity.categories,
                      otherTags: user.user.person.interests,
                    ),
                    const SizedBox(height: 0),
                    TextTile(title: "bio", text: person.bio),
                    const SizedBox(height: 50),
                  ])),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    like();
                  },
                  child: Icon(
                    Icons.pan_tool,
                    color: Colors.white,
                  ))));
    });
  }
}
