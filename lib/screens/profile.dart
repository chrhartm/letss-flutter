import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/imagetile.dart';
import '../widgets/nametile.dart';
import '../widgets/texttile.dart';
import '../widgets/tagtile.dart';
import '../provider/userprovider.dart';

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
                    age: user.user.person.age,
                    name: user.user.person.name,
                    job: user.user.person.job,
                    location: user.user.person.locationString),
                const SizedBox(height: 5),
                TextTile(title: "bio", text: user.user.person.bio),
                const SizedBox(height: 5),
                TagTile(tags: user.user.person.interests),
                const SizedBox(height: 150),
              ])),
          floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/profile/settings");
                          },
                          child: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.grey,
                          heroTag: null,
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup/name');
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ))
                      ]))));
    });
  }
}
