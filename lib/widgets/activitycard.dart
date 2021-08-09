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
    Person person = activity.getPerson();
    return Padding(
        padding: EdgeInsets.all(0.0),
        child: Scaffold(
            body: Card(
                color: Colors.grey[100],
                child: ListView(children: [
                  const SizedBox(height: 10),
                  LetssTile(activityName: activity.getName()),
                  const SizedBox(height: 10),
                  ImageTile(
                      title: "user picture",
                      image: activity.getPerson().getPictures()[0]),
                  const SizedBox(height: 10),
                  NameTile(
                      age: person.getAge(),
                      name: person.getName(),
                      job: person.getJob(),
                      location: person.getLocation()),
                  const SizedBox(height: 10),
                  TextTile(title: "activity", text: activity.getDescription()),
                  const SizedBox(height: 10),
                  TagTile(tags: activity.getCategories()),
                  const SizedBox(height: 10),
                  TextTile(title: "bio", text: person.getBio()),
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
