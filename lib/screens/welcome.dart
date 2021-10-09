import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:letss_app/screens/signupemail.dart';
import '../widgets/buttonprimary.dart';

class Welcome extends StatelessWidget {
  final List<String> activities = [
    'Let\'s get drunk and pretend to be British',
    'Let\'s be language buddies for French-Polish',
    'Let\'s forget the world over a boozy brunch',
    'Let\'s build a startup to connect people offline',
    'Let\'s go job shadowing at the chocolate factory',
    'Let\'s dress up as orks and play dungeons and dragons',
    'Let\'s get horses and ride through Mongolia',
    'Let\'s mine bitcoin with renewable energy',
    'Let\'s join our heavy metal band with your tin flute',
    'Let\'s hit the gym once a week and get ripped',
    'Let\'s go do something'
  ];

  List<AnimatedText> _generateActivities(BuildContext context) {
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpEmail()));
                      })
                ]))));
  }
}
