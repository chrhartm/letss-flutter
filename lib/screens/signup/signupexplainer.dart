import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/buttonaction.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpExplainer extends StatelessWidget {
  const SignUpExplainer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      ListTile(
          leading: ButtonAction(icon: Icons.add, heroTag: "add"),
          title: Text(AppLocalizations.of(context)!.signupExplainerAddTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.signupExplainerAddSubtitle)),
      ListTile(
          leading: ButtonAction(icon: Icons.lightbulb),
          title: Text(AppLocalizations.of(context)!.signupExplainerIdeaTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.signupExplainerIdeaSubtitle)),
      ListTile(
          leading: ButtonAction(icon: Icons.edit, heroTag: "edit"),
          title: Text(AppLocalizations.of(context)!.signupExplainerEditTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.signupExplainerEditSubtitle)),
      ListTile(
          leading: ButtonAction(icon: Icons.archive),
          title:
              Text(AppLocalizations.of(context)!.signupExplainerArchiveTitle),
          subtitle: Text(
              AppLocalizations.of(context)!.signupExplainerArchiveSubtitle)),
      ListTile(
          leading: ButtonAction(
              icon: !kIsWeb && Platform.isIOS ? Icons.ios_share : Icons.share),
          title: Text(AppLocalizations.of(context)!.signupExplainerShareTitle),
          subtitle:
              Text(AppLocalizations.of(context)!.signupExplainerShareSubtitle)),
      ListTile(
          leading: ButtonAction(icon: Icons.settings),
          title:
              Text(AppLocalizations.of(context)!.signupExplainerSettingsTitle),
          subtitle: Text(
              AppLocalizations.of(context)!.signupExplainerSettingsSubtitle)),
    ];

    return MyScaffold(
      body: HeaderScreen(
        top: "👨‍🏫",
        title: AppLocalizations.of(context)!.signupExplainerTitle,
        subtitle: AppLocalizations.of(context)!.signupExplainerSubtitle,
        back: true,
        child: Column(
          children: [
            Expanded(
                child: Column(children: [
              const SizedBox(height: 10),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    // Get padding at bottom
                    if (index == items.length) {
                      return Container();
                    }
                    return items[index];
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 15,
                    );
                  },
                ),
              ),
            ])),
            ButtonPrimary(
              onPressed: () {
                UserProvider user =
                    Provider.of<UserProvider>(context, listen: false);
                user.user.finishedSignupFlow = true;
                user.forceNotify();
                Navigator.popUntil(
                    context, (Route<dynamic> route) => route.isFirst);
              },
              text: AppLocalizations.of(context)!.signupExplainerNext,
            ),
          ],
        ),
      ),
    );
  }
}
