import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../backend/analyticsservice.dart';

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
        Text("😕", style: Theme.of(context).textTheme.headline1),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Search is currently disabled for your account",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 100),
        Text("🙌", style: Theme.of(context).textTheme.headline1),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "Enable it by ",
                      style: Theme.of(context).textTheme.headline3),
                  TextSpan(
                      text: "subscribing",
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primaryVariant),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          analytics.logEvent(name: "Search_Subscribe");
                          Navigator.pushNamed(context, '/support/pitch');
                          ;
                        }),
                  TextSpan(
                      text: " to one of our support badges",
                      style: Theme.of(context).textTheme.headline3),
                ])))
      ],
    ));
  }
}
