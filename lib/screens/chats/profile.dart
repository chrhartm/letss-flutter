import 'package:flutter/material.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../widgets/other/loader.dart';

class Profile extends StatelessWidget {
  const Profile({
    required this.person,
    Key? key,
  }) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        child: Scaffold(
            body: SafeArea(
                child: TextHeaderScreen(
                    back: true,
                    header: person.name + person.supporterBadge,
                    child: ProfileContent(person: person)))));
  }
}
