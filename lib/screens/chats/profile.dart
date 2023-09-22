import 'package:flutter/material.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../widgets/other/loader.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  static const routeName = '/profile/person';

  @override
  Widget build(BuildContext context) {
    final Person person = ModalRoute.of(context)!.settings.arguments as Person;

    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        overlayColor: Colors.black.withOpacity(0.6),
        child: Scaffold(
            body: SafeArea(
                child: TextHeaderScreen(
                    back: true,
                    header: person.name + person.supporterBadge,
                    child: ProfileContent(person: person)))));
  }
}
