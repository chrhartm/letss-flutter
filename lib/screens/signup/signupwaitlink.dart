import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';
import 'package:open_mail_app/open_mail_app.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpWaitLink extends StatelessWidget {
  const SignUpWaitLink({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return MyScaffold(
          body: HeaderScreen(
              top: "✉️",
              title: AppLocalizations.of(context)!.signupLinkTitle,
              subtitle: AppLocalizations.of(context)!.signupLinkSubtitle(
                  user.user.email == null ? "" : user.user.email!),
              back: true,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "🔑",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                          AppLocalizations.of(context)!.signupLinkMessage1,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "🕒",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                          AppLocalizations.of(context)!.signupLinkMessage2,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    const SizedBox(height: 30),
                    Flexible(
                        child: ButtonPrimary(
                      text: AppLocalizations.of(context)!.signupLinkAction,
                      onPressed: () async {
                        // Android: Will open mail app or show native picker.
                        // iOS: Will open mail app if single mail app found.
                        var result = await OpenMailApp.openMailApp();
                        if (context.mounted) {
                          // If no mail apps found, show error
                          if (!result.didOpen && !result.canOpen) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .signupLinkNoMail)));

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
                        }
                      },
                    ))
                  ])));
    });
  }
}
