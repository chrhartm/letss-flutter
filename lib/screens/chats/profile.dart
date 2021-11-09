import 'package:flutter/material.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';

class Profile extends StatelessWidget {
  const Profile({
    required this.person,
    Key? key,
  }) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: TextHeaderScreen(
                back: true,
                header: person.name,
                child: ProfileContent(person: person))));
  }
}
