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
          body: Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 0, left: 15.0, right: 15.0),
              child: ProfileContent(person: user.user.person, me: true)),
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
                            icon: Icons.settings),
                        const SizedBox(height: ButtonAction.buttonGap),
                        ButtonAction(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup/name');
                            },
                            icon: Icons.edit,
                            heroTag: "editProfile")
                      ]))));
    });
  }
}
