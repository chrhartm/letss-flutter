import 'package:flutter/material.dart';
import 'package:letss_app/screens/signup/widgets/profilepiccard.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

class SignUpPic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      int nPictures = user.user.person.nProfilePics;
      List<String> defaultNames = ["0", "1", "2", "3", "4", "5"];
      List<String> names = [];
      List<Widget> picTiles = [];
      for (int i = 0; i < nPictures; i++) {
        names.add(user.user.person.profilePicName(i));
        defaultNames.remove(names.last);
      }
      bool full = defaultNames.length == 0;
      if (!full) {
        names.add(defaultNames.first);
      }
      for (int i = 0; i < names.length; i++) {
        picTiles.add(Container(
            child: Align(
                alignment: Alignment.center,
                child: ProfilePicCard(
                    name: names[i],
                    empty: (i == (names.length - 1) && !full)))));
      }

      return Scaffold(
        body: SafeArea(
          child: SubTitleHeaderScreen(
            top: "🤳",
            title: 'Picture time',
            subtitle: 'Upload up to six, but one is enough for now',
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: GridView.count(
                      primary: false,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: picTiles)),
              ButtonPrimary(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup/interests');
                },
                text: 'Next',
                active: user.user.person.nProfilePics > 0,
              )
            ]),
            back: true,
          ),
        ),
      );
    });
  }
}
