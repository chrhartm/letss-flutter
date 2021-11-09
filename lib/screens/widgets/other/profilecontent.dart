import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/tiles/activitiestile.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:letss_app/screens/widgets/tiles/profilepictile.dart';
import 'package:letss_app/screens/widgets/tiles/nametile.dart';
import 'package:letss_app/screens/widgets/tiles/tagtile.dart';
import 'package:letss_app/screens/widgets/tiles/texttile.dart';

class ProfileContent extends StatelessWidget {
  ProfileContent({
    Key? key,
    required this.person,
    this.me = false,
  }) : super(key: key);

  final Person person;
  final bool me;

  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [
      ProfilePicTile(title: "user picture", person: person),
      const SizedBox(height: 5),
      NameTile(person: person),
      const SizedBox(height: 5),
      TextTile(title: "bio", text: person.bio),
      const SizedBox(height: 5),
      TagTile(
        tags: person.interests,
        interests: true,
      ),
    ];
    if (!this.me) {
      tiles.add(ActivitiesTile(person: person));
      tiles.add(FlagTile(
          flagger: person,
          flagged:
              Provider.of<UserProvider>(context, listen: false).user.person));
    }
    tiles.add(const SizedBox(height: 150));

    return Scaffold(
        body: ListView(children: tiles));
  }
}
