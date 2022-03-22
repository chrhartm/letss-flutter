import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';

class SupportThanks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      TextStyle headingStyle = Theme.of(context).textTheme.headline4!;
      TextStyle bodyStyle = Theme.of(context).textTheme.bodyText2!;
      TextStyle emojiStyle = Theme.of(context).textTheme.headline1!;
      return Container(
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("❤️", style: emojiStyle)),
              Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Thank you for supporting us!",
                            style: headingStyle),
                        TextSpan(
                            text:
                                "\n\nWe really appreciate your help in sustaining our mission! You can review your subscriptions in our settings page at any time.",
                            style: bodyStyle),
                      ]))),
            ])))),
      );
    });
  }
}
