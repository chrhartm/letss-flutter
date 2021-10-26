import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import '../widgets/buttons/buttonprimary.dart';

class Welcome extends StatelessWidget {
  List<AnimatedText> _generateActivities(BuildContext context) {
    List<dynamic> activities =
        RemoteConfigService.getJson("welcome_activities")["activities"];
    List<AnimatedText> acts = [];
    for (int i = 0; i < activities.length; i++) {
      acts.add(TyperAnimatedText(activities[i],
          textStyle: Theme.of(context).textTheme.headline1));
    }
    return acts;
  }

  @override
  Widget build(BuildContext context) {
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
                      })
                ]))));
  }
}
