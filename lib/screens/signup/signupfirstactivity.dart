import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpFirstActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubtitleHeaderScreen(
          top: "🎉",
          title: AppLocalizations.of(context)!.signupActivityTitle,
          subtitle: AppLocalizations.of(context)!.signupActivitySubtitle,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text("💡",
                        style: Theme.of(context).textTheme.displayMedium),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          AppLocalizations.of(context)!.signupActivityExplainer1,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 100),
                    Text("✍️",
                        style: Theme.of(context).textTheme.displayMedium),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                          AppLocalizations.of(context)!.signupActivityExplainer2,
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onPressed: () {
                  Provider.of<MyActivitiesProvider>(context, listen: false)
                      .addNewActivity(context);
                },
                text: AppLocalizations.of(context)!.signupActivityAction,
              ),
            ],
          ),
          back: false,
        ),
      ),
    );
  }
}
