import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/tiles/imagetile.dart';
import '../widgets/tiles/nametile.dart';
import '../widgets/tiles/texttile.dart';
import '../widgets/tiles/tagtile.dart';
import '../../provider/userprovider.dart';
import '../widgets/buttons/buttonaction.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: Padding(
              padding: EdgeInsets.all(15.0),
              child: ListView(children: [
                ImageTile(
                    title: "user picture", image: user.user.person.profilePic),
                const SizedBox(height: 5),
                NameTile(
                    person: user.user.person),
                const SizedBox(height: 5),
                TextTile(title: "bio", text: user.user.person.bio),
                const SizedBox(height: 5),
                TagTile(tags: user.user.person.interests),
                const SizedBox(height: 150),
              ])),
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
