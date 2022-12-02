import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/buttons/buttonprimary.dart';

class Welcome extends StatelessWidget {
  List<AnimatedText> _generateActivities(BuildContext context) {
    List<dynamic> activities =
        RemoteConfigService.getJson("welcome_activities")["activities"];
    List<AnimatedText> acts = [];
    TextStyle style = Theme.of(context).textTheme.headline1!;
    style = style.copyWith(
        color: Colors.transparent,
        shadows: [Shadow(offset: Offset(0, -2), color: style.color!)],
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 2,
        decorationColor: Theme.of(context).colorScheme.secondaryContainer);
    for (int i = 0; i < activities.length; i++) {
      acts.add(TyperAnimatedText(activities[i], textStyle: style));
    }
    return acts;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Theme.of(context).colorScheme.secondary);
    TextStyle linkstyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: Theme.of(context).colorScheme.primaryContainer);

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(children: [
                  const SizedBox(height: 30),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: _generateActivities(context)))),
                  const SizedBox(height: 30),
                  ButtonPrimary(
                      text: "Get Started",
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup/email');
                      }),
                  const SizedBox(height: 10),
                  new Center(
                    child: new RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: 'By registering, you accept our ',
                            style: textstyle,
                          ),
                          new TextSpan(
                            text: 'Terms and Conditions',
                            style: linkstyle,
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(RemoteConfigService
                                    .remoteConfig
                                    .getString('urlTnc')));
                              },
                          ),
                          new TextSpan(
                            text: ' and our ',
                            style: textstyle,
                          ),
                          new TextSpan(
                            text: 'Privacy Policy',
                            style: linkstyle,
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(RemoteConfigService
                                    .remoteConfig
                                    .getString('urlPrivacy')));
                              },
                          ),
                          new TextSpan(
                            text: '.',
                            style: textstyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30)
                ]))));
  }
}
