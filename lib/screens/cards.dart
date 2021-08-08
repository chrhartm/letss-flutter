import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../widgets/activitycard.dart';
import '../provider/activitiesprovider.dart';

class Cards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      return CardsWithConsumer(activities: activities);
    });
  }
}

class CardsWithConsumer extends StatelessWidget {
  const CardsWithConsumer({
    Key? key,
    required this.activities,
  }) : super(key: key);

  final ActivitiesProvider activities;

  @override
  Widget build(BuildContext context) {
    List<ActivityCard> cards = [];

    List<Activity> acts = activities.activities;

    for (int i = 0; i < acts.length; i++) {
      cards.add(ActivityCard(activity: acts[i], like: activities.like));
    }

    return Stack(
      alignment: Alignment.center,
      children: cards,
    );
  }
}
