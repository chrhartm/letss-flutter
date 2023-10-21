import 'package:flutter/material.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  static const routeName = '/profile/person';

  @override
  Widget build(BuildContext context) {
    final Person person = ModalRoute.of(context)!.settings.arguments as Person;

    return MyScaffold(
        body: TextHeaderScreen(
            back: true,
            header: person.name + person.supporterBadge,
            child: ProfileContent(person: person)));
  }
}
