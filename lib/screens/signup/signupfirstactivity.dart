import 'package:flutter/material.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpFirstActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    widgets.addAll([
      Expanded(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text("💡", style: Theme.of(context).textTheme.displayLarge),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text(
                  AppLocalizations.of(context)!.signupActivityExplainer1,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 50),
            Text("✍️", style: Theme.of(context).textTheme.displayLarge),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                  AppLocalizations.of(context)!.signupActivityExplainer2,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      ButtonPrimary(
        padding: ConfigService.config.forceAddActivity ? 16 : 0,
        onPressed: () {
          Provider.of<MyActivitiesProvider>(context, listen: false)
              .addNewActivity(context);
        },
        text: AppLocalizations.of(context)!.signupActivityAction,
      ),
    ]);

    if (!ConfigService.config.forceAddActivity) {
      widgets.add(ButtonPrimary(
        tertiary: true,
        onPressed: () {
          UserProvider user = Provider.of<UserProvider>(context, listen: false);
          user.user.finishedSignupFlow = true;
          user.forceNotify();
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        text: AppLocalizations.of(context)!.signupActivitySkip,
      ));
    }

    return MyScaffold(
      body: HeaderScreen(
        top: "🎉",
        title: AppLocalizations.of(context)!.signupActivityTitle,
        subtitle: AppLocalizations.of(context)!.signupActivitySubtitle,
        child: Column(children: widgets),
        back: false,
      ),
    );
  }
}
