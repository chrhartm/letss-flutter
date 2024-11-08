import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/other/profilecontent.dart';
import '../../provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: HeaderScreen(
              back: false,
              trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/profile/settings");
                  },
                  icon: const Icon(Icons.settings)),
              title: AppLocalizations.of(context)!.profileTitle,
              titleWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(AppLocalizations.of(context)!.profileTitle,
                      style: Theme.of(context).textTheme.displayMedium!),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/profile/settings");
                      },
                      icon: const Icon(Icons.settings))
                ],
              ),
              child: ProfileContent(
                  person: user.user.person, me: true, editable: true)));
    });
  }
}
