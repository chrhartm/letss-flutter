import 'package:flutter/material.dart';
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
    return Padding(
        padding: EdgeInsets.all(0.0),
        child: Scaffold(
            body: Card(
                color: Colors.white,
                child: ListView(children: [
                  const SizedBox(height: 5),
                  LetssTile(activityName: activity.name),
                  const SizedBox(height: 5),
                  ImageTile(title: "user picture", image: person.pics[0]),
                  const SizedBox(height: 5),
                  NameTile(
                      age: person.age,
                      name: person.name,
                      job: person.job,
                      location: person.location),
                  const SizedBox(height: 5),
                  TextTile(title: "activity", text: activity.description),
                  const SizedBox(height: 5),
                  TagTile(tags: activity.categories),
                  const SizedBox(height: 5),
                  TextTile(title: "bio", text: person.bio),
                ])),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  like();
                },
                child: Icon(
                  Icons.pan_tool,
                  color: Colors.white,
                ))));
  }
}
