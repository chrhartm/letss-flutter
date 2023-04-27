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
    this.editable = false,
  }) : super(key: key);

  final Person person;
  final bool me;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    Widget profilePic = ProfilePicTile(title: "user picture", person: person);
    Widget? bio =
        person.hasBio ? TextTile(title: "bio", text: person.bio!) : null;
    Widget? interests = person.hasInterests
        ? TagTile(
            tags: person.interests!,
            interests: true,
          )
        : null;
    Widget name = NameTile(person: person);

    List<Widget> tiles = [];
    if (editable) {
      tiles.add(GestureDetector(
          child: profilePic,
          onTap: () {
            Navigator.pushNamed(context, "/profile/pic");
          }));
    } else {
      tiles.add(profilePic);
    }
    tiles.add(const SizedBox(height: 5));
    if (editable) {
      tiles.add(GestureDetector(
          child: name,
          onTap: () {
            Navigator.pushNamed(context, "/profile/name");
          }));
    } else {
      tiles.add(name);
    }
    tiles.add(
      const SizedBox(height: 5),
    );
    if (bio != null) {
      if (editable) {
        tiles.add(GestureDetector(
            child: bio,
            onTap: () {
              Navigator.pushNamed(context, "/profile/bio");
            }));
      } else {
        tiles.add(bio);
      }
      tiles.add(const SizedBox(height: 5));
    }
    if (interests != null) {
      if (editable) {
        tiles.add(GestureDetector(
            child: interests,
            onTap: () {
              Navigator.pushNamed(context, "/profile/interests");
            }));
      } else {
        tiles.add(interests);
      }
    }

    if (!this.me) {
      tiles.add(ActivitiesTile(person: person));
      tiles.add(FlagTile(
          flagger: person,
          flagged:
              Provider.of<UserProvider>(context, listen: false).user.person));
    }
    tiles.add(const SizedBox(height: 150));

    return Scaffold(body: ListView(children: tiles));
  }
}
