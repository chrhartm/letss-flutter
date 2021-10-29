import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import '../../provider/userprovider.dart';
import '../widgets/buttons/buttonaction.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: ProfileContent(person: user.user.person, me: true),
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
                          icon: Icons.settings,
                          hero: null,
                        ),
                        const SizedBox(height: ButtonAction.buttonGap),
                        ButtonAction(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup/name');
                            },
                            icon: Icons.edit,
                            hero: true)
                      ]))));
    });
  }
}
