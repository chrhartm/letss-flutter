import 'package:flutter/material.dart';
import 'package:letss_app/screens/signup/widgets/profilepiccard.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPic extends StatelessWidget {
  final bool signup;

  const SignUpPic({this.signup = true, super.key});

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
      bool full = defaultNames.isEmpty;
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
                      return DragTarget<int>(onAcceptWithDetails: (details) {
                        Provider.of<UserProvider>(context, listen: false)
                            .switchPics(details.data, index);
                      }, builder: (context, candidateData, rejectedData) {
                        return Draggable<int>(
                          feedback: tile,
                          data: index,
                          child: tile,
                        );
                      });
                    }
                  });
                })),
      ];
      columnWidgets.add(ButtonPrimary(
        onPressed: () {
          signup
              ? Navigator.pushNamed(context, "/signup/notifications")
              : Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
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
          back: signup ? true : false,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnWidgets),
        ),
      );
    });
  }
}
