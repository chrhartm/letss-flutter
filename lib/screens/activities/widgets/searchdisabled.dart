import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
        Text("😕", style: Theme.of(context).textTheme.displayLarge),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "Search is only available for supporters.",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 100),
        Text("🙌", style: Theme.of(context).textTheme.displayLarge),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: "Get it by ",
                      style: Theme.of(context).textTheme.displaySmall),
                  TextSpan(
                      text: "subscribing",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/support/pitch');
                          ;
                        }),
                  TextSpan(
                      text: " to one of our support badges.",
                      style: Theme.of(context).textTheme.displaySmall),
                ])))
      ],
    ));
  }
}
