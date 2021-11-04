import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import '../../../models/person.dart';
import '../../widgets/tiles/texttile.dart';
import '../../widgets/tiles/tagtile.dart';
import '../../widgets/tiles/imagetile.dart';
import '../../widgets/tiles/nametile.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    this.back = false,
  }) : super(key: key);

  final Activity activity;
  final bool back;

  List<Widget> buildList(Person userPerson) {
    Person person = activity.person;

    List<Widget> widgets = [
      const SizedBox(height: 0),
      ImageTile(title: "user picture", image: person.profilePic),
      const SizedBox(height: 0),
      NameTile(person: person),
      const SizedBox(height: 0),
      TextTile(title: "activity", text: activity.description),
      const SizedBox(height: 0),
      TagTile(
        tags: activity.categories,
        otherTags: userPerson.interests,
      ),
      const SizedBox(height: 0),
      TextTile(title: "bio", text: person.bio)
    ];
    if (userPerson.uid != activity.person.uid) {
      widgets.add(FlagTile(
          flagger: userPerson, flagged: activity.person, activity: activity));
    }
    widgets.add(const SizedBox(height: 150));
    return widgets;
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
          back: back,
          child: ListView(children: buildList(user.user.person)),
        ),
        elevation: 0,
      );
    });
  }
}
