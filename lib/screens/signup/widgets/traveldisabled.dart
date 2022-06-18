import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../backend/analyticsservice.dart';

class TravelDisabled extends StatelessWidget {
  const TravelDisabled({
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
              "Travel is only available for supporters.",
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
                      text: "Get it by ",
                      style: Theme.of(context).textTheme.headline3),
                  TextSpan(
                      text: "subscribing",
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).colorScheme.primaryContainer),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          analytics.logEvent(name: "Travel_Subscribe");
                          Navigator.pushNamed(context, '/support/pitch');
                          ;
                        }),
                  TextSpan(
                      text: " to one of our support badges.",
                      style: Theme.of(context).textTheme.headline3),
                ])))
      ],
    ));
  }
}
