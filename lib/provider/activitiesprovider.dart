import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/person.dart';

class ActivitiesProvider extends ChangeNotifier {
  final List<Activity> _activities = [];

  ActivitiesProvider() {
    getMore();
  }

  UnmodifiableListView<Activity> get activities {
    if (_activities.isEmpty) {
      getMore();
    }
    return UnmodifiableListView(_activities);
  }

  void like() {
    _activities.removeLast();
    notifyListeners();

    if (_activities.isEmpty) {
      getMore();
    }
  }

  void getMore() {
    _activities.add(Activity(
        "Let's steal horses and ride to Mongolia",
        "I can't really ride but doesn't matter right? Let's just have some fun",
        ["riding", "travel", "criminal"],
        Person(
            "Joe Juggler",
            "Just a juggler who is sick of circus. Not looking for dates, just friendship",
            ["juggling", "riding", "friendship", "yourmom"])));
    _activities.add(Activity(
        "Let's practice dirty dancing moves all night long",
        "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
        ["dancing", "date", "exercise"],
        Person(
            "Betty Beautiful",
            "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
            ["dancing", "friendship", "dating", "riding", "volleyball"])));

    notifyListeners();
  }
}
