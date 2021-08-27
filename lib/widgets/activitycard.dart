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
    this.withTitle = true,
  }) : super(key: key);

  final Activity activity;
  final bool withTitle;

  List<Widget> buildList(UserProvider user) {
    List<Widget> cardlist = [const SizedBox(height: 0)];
    Person person = activity.person;

    if (this.withTitle) {
      cardlist.add(LetssTile(activityName: activity.name));
    }
    return cardlist +
        [
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
          const SizedBox(height: 150),
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Padding(
        padding: EdgeInsets.all(0.0),
        child: Card(
          color: Colors.white,
          child: ListView(
            children: buildList(user),
          ),
          elevation: 0,
        ),
      );
    });
  }
}
