import 'package:flutter/material.dart';
import '../widgets/textheaderscreen.dart';
import '../models/activity.dart';
import '../models/like.dart';
import '../models/person.dart';
import '../widgets/messagetile.dart';
import '../widgets/texttile.dart';
import '../widgets/tagtile.dart';
import '../widgets/imagetile.dart';
import '../widgets/nametile.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({
    Key? key,
    required this.activity,
    required this.like,
  }) : super(key: key);

  final Activity activity;
  final Like like;

  void _match() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    Person person = like.person;
    return Scaffold(
        body: SafeArea(
            child: TextHeaderScreen(
                header: activity.name,
                back: true,
                child: ListView(children: [
                  const SizedBox(height: 5),
                  MessageTile(text: like.message, me: false),
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
                  TextTile(title: "bio", text: person.bio)
                ]))),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _match();
            },
            child: Icon(
              Icons.chat_bubble,
              color: Colors.white,
            )));
  }
}
