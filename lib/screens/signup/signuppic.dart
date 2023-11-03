import 'package:flutter/material.dart';
import 'package:letss_app/screens/signup/widgets/profilepiccard.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

import '../../backend/configservice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPic extends StatelessWidget {
  final bool signup;

  SignUpPic({this.signup = true, Key? key}) : super(key: key);

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
        picTiles.add(ProfilePicCard(
            name: names[i], empty: (i == (names.length - 1) && !full)));
      }

      List<Widget> columnWidgets = [
        const SizedBox(height: 20),
        Expanded(
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                itemCount: picTiles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return LayoutBuilder(builder: (context, constraints) {
                    Widget tile = Material(
                        child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: constraints.maxWidth),
                            child: picTiles[index]));
                    if (index == picTiles.length - 1 && !full) {
                      return tile;
                    } else {
                      return DragTarget<int>(onAccept: (data) {
                        Provider.of<UserProvider>(context, listen: false)
                            .switchPics(data, index);
                      }, builder: (context, candidateData, rejectedData) {
                        return Draggable<int>(
                          feedback: tile,
                          child: tile,
                          data: index,
                        );
                      });
                    }
                  });
                })),
      ];
      columnWidgets.add(ButtonPrimary(
        onPressed: () {
          if (signup) {
            if (!ConfigService.config.forceAddActivity) {
              UserProvider user =
                  Provider.of<UserProvider>(context, listen: false);
              user.user.finishedSignupFlow = true;
              user.forceNotify();
            }
          }
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        text: signup
            ? AppLocalizations.of(context)!.signupPicNextSignup
            : AppLocalizations.of(context)!.signupPicNextProfile,
        active: user.user.person.nProfilePics > 0,
      ));

      return MyScaffold(
        body: HeaderScreen(
          top: "🤳",
          title: AppLocalizations.of(context)!.signupPicTitle,
          subtitle: AppLocalizations.of(context)!.signupPicSubtitle,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnWidgets),
          back: signup ? true : false,
        ),
      );
    });
  }
}
