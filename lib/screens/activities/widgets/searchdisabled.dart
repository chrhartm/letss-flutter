import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SearchDisabled extends StatelessWidget {
  const SearchDisabled({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(height: 100),
        Text("😕", style: Theme.of(context).textTheme.displayMedium),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              AppLocalizations.of(context)!.searchDisabledTitle,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 100),
        Text("🙌", style: Theme.of(context).textTheme.displayMedium),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: AppLocalizations.of(context)!.searchDisabledPrompt1,
                      style: Theme.of(context).textTheme.displaySmall),
                  TextSpan(
                      text: AppLocalizations.of(context)!.searchDisabledLink,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/support/pitch');
                        }),
                  TextSpan(
                      text: AppLocalizations.of(context)!.searchDisabledPrompt2,
                      style: Theme.of(context).textTheme.displaySmall),
                ])))
      ],
    ));
  }
}
