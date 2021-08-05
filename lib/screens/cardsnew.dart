import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/person.dart';
import '../widgets/activitycard.dart';

class CardsNew extends StatefulWidget {
  const CardsNew({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardsNewState();
}

class _CardsNewState extends State<CardsNew> {
  List<Widget> _cardList = [];

  @override
  void initState() {
    super.initState();
    _cardList = _getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: _cardList,
    );
  }

  List<Widget> _getCards() {
    List<Activity> activities = [];
    activities.add(Activity(
        "Let's steal horses and ride to Mongolia",
        "I can't really ride but doesn't matter right? Let's just have some fun",
        ["riding", "travel", "criminal"],
        Person(
            "Joe Juggler",
            "Just a juggler who is sick of circus. Not looking for dates, just friendship",
            ["juggling", "riding", "friendship", "yourmom"])));
    activities.add(Activity(
        "Let's practice dirty dancing moves all night long",
        "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
        ["dancing", "date", "exercise"],
        Person(
            "Betty Beautiful",
            "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
            ["dancing", "friendship", "dating", "riding", "volleyball"])));

    List<ActivityCard> cards = [];
    cards.add(ActivityCard(activity: activities[0]));
    cards.add(ActivityCard(activity: activities[1]));

    return cards;
  }
}
