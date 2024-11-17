import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class NoCoinsDialog extends StatelessWidget {
  const NoCoinsDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      TextStyle headingStyle = Theme.of(context).textTheme.headlineMedium!;
      TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;
      TextStyle emojiStyle = Theme.of(context).textTheme.displayMedium!;
      return Container(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("😔", style: emojiStyle)),
              Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!.noCoinsLeft,
                            style: headingStyle),
                        TextSpan(
                            text:
                            AppLocalizations.of(context)!.noCoinsLeftMessage,
                            style: bodyStyle),
                      ]))),
            ])))),
      );
    });
  }
}
