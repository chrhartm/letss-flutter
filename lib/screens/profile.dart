import 'package:flutter/material.dart';
import 'signupname.dart';
import '../widgets/imagetile.dart';
import '../widgets/nametile.dart';
import '../widgets/texttile.dart';
import '../widgets/tagtile.dart';
import '../provider/userprovider.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Padding(
          padding: EdgeInsets.all(0.0),
          child: Scaffold(
              body: ListView(children: [
                ImageTile(
                    title: "user picture", image: user.user.person.profilePic),
                const SizedBox(height: 5),
                NameTile(
                    age: user.user.person.age,
                    name: user.user.person.name,
                    job: user.user.person.job,
                    location: user.user.person.location),
                const SizedBox(height: 5),
                TextTile(title: "bio", text: user.user.person.bio),
                const SizedBox(height: 5),
                TagTile(tags: user.user.person.interests),
              ]),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpName()));
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ))));
    });
  }
}
