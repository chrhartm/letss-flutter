import 'package:flutter/material.dart';
import 'package:letss_app/screens/activities/widgets/activityswipecard.dart';
import 'package:letss_app/screens/activities/widgets/promptactivityaddcard.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import 'widgets/nocards.dart';
import '../../provider/activitiesprovider.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
  }) : super(key: key);

  List<Widget> _createCards({required ActivitiesProvider acts}) {
    List<Widget> cards = [];

    if (acts.status == "EMPTY") {
      cards.add(Scaffold(body: NoCards()));
    } else if (acts.activities.length == 0 && acts.promptShown) {
      cards.add(Scaffold(body: Loader()));
    } else {
      acts.promptShown = false;
      cards.add(Scaffold(body: PromptActivityAddCard(onSkip: acts.promptPass)));
      for (int i = 0; i < acts.activities.length; i++) {
        // take length-i-1 to avoid overloading when more activities added to
        // list since here we stack so that last item on stack will be shown
        // first

        cards.add(ActivitySwipeCard(
            activity: acts.activities[acts.activities.length - i - 1]));
      }
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      List<Widget> cards = _createCards(acts: activities);
      return Scaffold(
        body: Stack(alignment: Alignment.bottomCenter, children: [
          Stack(
            alignment: Alignment.center,
            children: cards,
          )
        ]),
      );
    });
  }
}
