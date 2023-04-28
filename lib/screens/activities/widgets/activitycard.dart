import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import '../../../models/person.dart';
import '../../widgets/tiles/actionstile.dart';
import '../../widgets/tiles/participantstile.dart';
import '../../widgets/tiles/texttile.dart';
import '../../widgets/tiles/tagtile.dart';
import '../../widgets/tiles/profilepictile.dart';
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
      ProfilePicTile(title: "user picture", person: person),
      const SizedBox(height: 0),
      NameTile(
        person: person,
        padding: false,
      ),
      const SizedBox(height: 0),
      ActionsTile(
        person: person,
      ),
      const SizedBox(height: 10),
    ];

    if (activity.hasParticipants) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(ParticipantsTile(activity: activity));
    }
    if (activity.hasDescription) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TextTile(title: "idea", text: activity.description!));
    }
    if (activity.hasCategories) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TagTile(
        tags: activity.categories!,
        otherTags: userPerson.hasInterests ? userPerson.interests! : [],
      ));
    }
    if (person.hasBio) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TextTile(title: "bio", text: person.bio!));
    }
    if (person.hasInterests) {
      widgets.add(const SizedBox(height: 0));
      widgets.add(TagTile(
        interests: true,
        tags: person.interests!,
        otherTags: userPerson.hasInterests ? userPerson.interests! : [],
      ));
    }
    if (userPerson.uid != activity.person.uid) {
      widgets.add(FlagTile(
          flagger: userPerson, flagged: activity.person, activity: activity));
    } else {
      widgets
          .add(TextTile(text: activity.locationString, title: "idea location"));
    }

    widgets.add(const SizedBox(height: 150));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return TextHeaderScreen(
        header: activity.name,
        back: back,
        underline: true,
        child: ListView(children: buildList(user.user.person)),
      );
    });
  }
}
