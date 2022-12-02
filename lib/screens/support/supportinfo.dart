import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String url) async {
  Uri uri = Uri.parse(url);
  await canLaunchUrl(uri)
      ? await launchUrl(uri)
      : LoggerService.log('Could not open $url', level: "e");
}

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
                                "\nWe value your time. We want you to spend as little time with us and as much time with the people you meet through us. That means, however, that we can't rely on ads to pay our bills. By supporting us, you help us to stay true to our mission.",
                            style: bodyStyle),
                        TextSpan(
                            text: "\n\nWe want to recognize our supporters",
                            style: headingStyle),
                        TextSpan(
                          text:
                              "\nExtra features just for you! By supporting us, you will be able to search nearby activities by interest, travel to other cities, and get more likes per day.",
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
                                _launchURL(RemoteConfigService.remoteConfig
                                    .getString("urlSupport"));
                              }),
                        TextSpan(text: ".", style: bodyStyle),
                      ],
                    ))),
            const SizedBox(height: 30),
          ])))),
    );
  }
}
