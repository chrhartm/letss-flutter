import 'package:flutter/material.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';

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
            child: HeaderScreen(
                back: true,
                header: ListTile(
                  title: Text(person.name,
                      style: Theme.of(context).textTheme.headline1),
                ),
                child: ProfileContent(person: person))));
  }
}
