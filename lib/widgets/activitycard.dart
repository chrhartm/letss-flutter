import 'package:flutter/material.dart';
import 'package:letss_app/widgets/textheaderscreen.dart';
import '../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../models/person.dart';
import 'texttile.dart';
import 'tagtile.dart';
import 'imagetile.dart';
import 'nametile.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    this.back = false,
  }) : super(key: key);

  final Activity activity;
  final bool back;

  List<Widget> buildList(UserProvider user) {
    Person person = activity.person;

    return [
      const SizedBox(height: 0),
      ImageTile(title: "user picture", image: person.profilePic),
      const SizedBox(height: 0),
      NameTile(
          age: person.age,
          name: person.name,
          job: person.job,
          location: person.locationString),
      const SizedBox(height: 0),
      TextTile(title: "activity", text: activity.description),
      const SizedBox(height: 0),
      TagTile(
        tags: activity.categories,
        otherTags: user.user.person.interests,
      ),
      const SizedBox(height: 0),
      TextTile(title: "bio", text: person.bio),
      const SizedBox(height: 150),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Card(
        borderOnForeground: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0),
          borderRadius: BorderRadius.circular(0),
        ),
        margin: EdgeInsets.zero,
        child: TextHeaderScreen(
          header: activity.name,
          back: this.back,
          child: ListView(children: buildList(user)),
        ),
        elevation: 0,
      );
    });
  }
}
