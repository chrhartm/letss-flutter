import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = Theme.of(context).textTheme.headline4!;
    TextStyle bodyStyle = Theme.of(context).textTheme.bodyText2!;
    TextStyle emojiStyle = Theme.of(context).textTheme.headline1!;
    return Container(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Text("🙌", style: emojiStyle)),
            Align(
                alignment: Alignment.topLeft,
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "We focus on offline, not online",
                            style: headingStyle),
                        TextSpan(
                            text:
                                "\nMost social apps make money through either ads or premium features. Both mean that if you spend more time on the app, you will earn them more money. Either by seeing more ads or by becoming impatient with the time it takes to find good matches so that you're willing to go premium.",
                            style: bodyStyle),
                        TextSpan(
                            text:
                                "\n\nWe value your time. We want you to spend as little time with us and as much time with the people you meet through us. To keep it this way, we need you to support us, so that we don't have to switch to ads or premium features to pay our bills.",
                            style: bodyStyle),
                        TextSpan(
                            text: "\n\nWe are radically transparent",
                            style: headingStyle),
                        TextSpan(
                          text:
                              "\nWe want to make sure you know where your money goes. To help you understand this, we publish monthly updates on our income and spending on our ",
                          style: bodyStyle,
                        ),
                        TextSpan(
                            text: "transparency page",
                            style: new TextStyle(color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launch(RemoteConfigService.remoteConfig
                                    .getString("urlTransparency"));
                              }),
                        TextSpan(
                          text: ". Check it out!",
                          style: bodyStyle,
                        ),
                        TextSpan(
                            text: "\n\nWe want to hear from you",
                            style: headingStyle),
                        TextSpan(
                            text:
                                "\nWe're a young company that still has lot's to learn. Not sure about supporting us yet? Looking for an extra feature? Have questions about our business model? Please ",
                            style: bodyStyle),
                        TextSpan(
                            text: "reach out to us",
                            style: new TextStyle(color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launch(RemoteConfigService.remoteConfig
                                    .getString("urlSupport"));
                              }),
                        TextSpan(text: ".", style: bodyStyle),
                      ],
                    )))
          ])))),
    );
  }
}
