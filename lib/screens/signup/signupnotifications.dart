import 'package:flutter/material.dart';
import 'package:letss_app/backend/messagingservice.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpNotifications extends StatelessWidget {
  void pop(BuildContext context) {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "🔔",
        title: AppLocalizations.of(context)!.signupNotificationsTitle,
        subtitle: AppLocalizations.of(context)!.signupNotificationsSubtitle,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text("📬", style: Theme.of(context).textTheme.displayLarge),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        AppLocalizations.of(context)!
                            .signupNotificationsExplainer,
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
            ButtonPrimary(
              onPressed: () {
                MessagingService.requestPermissions().then((_) {
                  pop(context);
                });
              },
              padding: 0,
              text: AppLocalizations.of(context)!.signupNotificationsAction,
            ),
            ButtonPrimary(
              tertiary: true,
              onPressed: () => pop(context),
              text: AppLocalizations.of(context)!.signupNotificationsSkip,
            )
          ],
        ),
        back: false,
      ),
    );
  }
}
