import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_mail_app/open_mail_app.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpWaitLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: SafeArea(
              child: SubtitleHeaderScreen(
                  top: "✉️",
                  title: AppLocalizations.of(context)!.signupLinkTitle,
                  subtitle: AppLocalizations.of(context)!.signupLinkSubtitle(user.user.email == null ? "" : user.user.email!),
                  back: true,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                              AppLocalizations.of(context)!.signupLinkMessage,
                              style: Theme.of(context).textTheme.displaySmall),
                        ),
                        const SizedBox(height: 30),
                        ButtonPrimary(
                          text: AppLocalizations.of(context)!.signupLinkAction,
                          onPressed: () async {
                            // Android: Will open mail app or show native picker.
                            // iOS: Will open mail app if single mail app found.
                            var result = await OpenMailApp.openMailApp();

                            // If no mail apps found, show error
                            if (!result.didOpen && !result.canOpen) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(AppLocalizations.of(context)!.signupLinkNoMail)));

                              // iOS: if multiple mail apps found, show dialog to select.
                              // There is no native intent/default app system in iOS so
                              // you have to do it yourself.
                            } else if (!result.didOpen && result.canOpen) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return MailAppPickerDialog(
                                    mailApps: result.options,
                                  );
                                },
                              );
                            }
                          },
                        )
                      ]))));
    });
  }
}
