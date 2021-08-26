import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../widgets/activitycard.dart';
import '../widgets/loader.dart';
import '../provider/activitiesprovider.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
  }) : super(key: key);

  List<Widget> _createCards(List<Activity> acts, Function like) {
    List<Widget> cards = [];

    cards.add(Card(child: Loader()));

    for (int i = 0; i < acts.length; i++) {
      cards.add(ActivityCard(activity: acts[i], like: like));
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      return Stack(alignment: Alignment.bottomCenter, children: [
        Stack(
          alignment: Alignment.center,
          children: _createCards(activities.activities, activities.like),
        )
      ]);
    });
  }
}
