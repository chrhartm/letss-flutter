import 'package:flutter/material.dart';
import 'package:letss_app/screens/activities/widgets/activityswipecard.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import 'widgets/nocards.dart';
import '../../provider/activitiesprovider.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
  }) : super(key: key);

  List<Widget> _createCards(
      {required List<Activity> acts, required String status}) {
    List<Widget> cards = [];

    if (status == "EMPTY") {
      cards.add(Card(child: NoCards()));
    } else if (acts.length == 0) {
      cards.add(Card(child: Loader()));
    } else {
      for (int i = 0; i < acts.length; i++) {
        cards.add(ActivitySwipeCard(activity: acts[i]));
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      List<Widget> cards =
          _createCards(acts: activities.activities, status: activities.status);
      if (cards.length <= 1) {
        Provider.of<ActivitiesProvider>(context, listen: false).getMore();
      }
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
