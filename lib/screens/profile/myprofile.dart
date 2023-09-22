import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import '../../provider/userprovider.dart';
import '../widgets/buttons/buttonaction.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: TextHeaderScreen(
              back: false,
              header: AppLocalizations.of(context)!.profileTitle,
              child: ProfileContent(
                  person: user.user.person, me: true, editable: true)),
          floatingActionButton: Padding(
              padding: ButtonAction.buttonPadding,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonAction(
                            onPressed: () {
                              Navigator.pushNamed(context, "/profile/settings");
                            },
                            icon: Icons.settings)
                      ]))));
    });
  }
}
