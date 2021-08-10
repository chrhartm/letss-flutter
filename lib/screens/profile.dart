import 'package:flutter/material.dart';
import '../widgets/imagetile.dart';
import '../widgets/nametile.dart';
import '../widgets/texttile.dart';
import '../widgets/tagtile.dart';
import '../provider/userprovider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  void edit() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Padding(
          padding: EdgeInsets.all(0.0),
          child: Scaffold(
              body: ListView(children: [
                ImageTile(title: "user picture", image: user.person.pics[0]),
                const SizedBox(height: 5),
                NameTile(
                    age: user.person.age,
                    name: user.person.name,
                    job: user.person.job,
                    location: user.person.location),
                const SizedBox(height: 5),
                TextTile(title: "bio", text: user.person.bio),
                const SizedBox(height: 5),
                TagTile(tags: user.person.interests),
              ]),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    edit();
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ))));
    });
  }
}
