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
      return Scaffold(
        body: SafeArea(
          child: SubTitleHeaderScreen(
            top: "🤳",
            title: 'Picture time',
            subtitle: 'Gives us your best smile :)',
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.center, child: ProfilePicCard())),
              ButtonPrimary(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup/interests');
                },
                text: 'Next',
                active: user.user.person.profilePicURL != "",
              )
            ]),
            back: true,
          ),
        ),
      );
    });
  }
}
