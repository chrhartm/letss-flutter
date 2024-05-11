import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoActivities extends StatelessWidget {
  const NoActivities({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(height: 50),
        Text("😶", style: Theme.of(context).textTheme.displayLarge),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              AppLocalizations.of(context)!.noMyActivitiesTitle,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 50),
        Text("😊", style: Theme.of(context).textTheme.displayLarge),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(AppLocalizations.of(context)!.noMyActivitiesMessage,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center),
        )
      ],
    ));
  }
}
