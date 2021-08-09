import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/person.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

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

  void getMore() async {
    Uint8List dummyimage1 =
        (await rootBundle.load('assets/images/dummy_avatar_1.jpeg'))
            .buffer
            .asUint8List();
    Uint8List dummyimage2 =
        (await rootBundle.load('assets/images/dummy_avatar_2.jpeg'))
            .buffer
            .asUint8List();
    _activities.add(Activity(
        "Let's steal horses and ride to Mongolia",
        "I can't really ride but doesn't matter right? Let's just have some fun",
        ["riding", "travel", "criminal"],
        Person(
            "Joe Juggler",
            "Just a juggler who is sick of circus. Not looking for dates, just friendship",
            DateTime(2000, 1, 1),
            "Cabin attendant at KLM",
            "5km from you",
            ["juggling", "riding", "friendship", "yourmom"],
            [dummyimage1])));
    _activities.add(Activity(
        "Let's practice dirty dancing moves all night long",
        "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
        ["dancing", "date", "exercise"],
        Person(
            "Betty Beautiful",
            "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
            DateTime(1998, 9, 10),
            "Candy shop owner",
            "Amsterdam Noord",
            ["dancing", "friendship", "dating", "riding", "volleyball"],
            [dummyimage2])));

    notifyListeners();
  }
}
