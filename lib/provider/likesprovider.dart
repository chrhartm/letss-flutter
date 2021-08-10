import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import '../models/activity.dart';
import '../models/person.dart';
import '../models/like.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class LikesProvider extends ChangeNotifier {
  List<Activity> _myActivities = [];
  UserProvider _user = UserProvider();

  UnmodifiableListView<Activity> get myActivities {
    return UnmodifiableListView(_myActivities);
  }

  LikesProvider(UserProvider user) {
    this._user = user;
    loadMyActivities();
  }

  void loadMyActivities() async {
    Uint8List dummyimage1 =
        (await rootBundle.load('assets/images/dummy_avatar_1.jpeg'))
            .buffer
            .asUint8List();
    Uint8List dummyimage2 =
        (await rootBundle.load('assets/images/dummy_avatar_2.jpeg'))
            .buffer
            .asUint8List();

    _myActivities.add(Activity(
        "Let's learn how to DJ techno music",
        "Love dancing to techno but suck at DJing - can't be so hard, no?",
        ["music", "techno", "learning"],
        this._user.person,
        likes: [
          Like(
              Person(
                  "Joe Juggler",
                  "Just a juggler who is sick of circus. Not looking for dates, just friendship",
                  DateTime(2000, 1, 1),
                  "Cabin attendant at KLM",
                  "5km from you",
                  ["juggling", "riding", "friendship", "yourmom"],
                  [dummyimage1]),
              "Do you know Boris Bechja? He's only plugging in a USB stick! We can do the same :)",
              DateTime(2021, 8, 7, 11, 12)),
          Like(
              Person(
                  "Betty Beautiful",
                  "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
                  DateTime(1998, 9, 10),
                  "Candy shop owner",
                  "Amsterdam Noord",
                  ["dancing", "friendship", "dating", "riding", "volleyball"],
                  [dummyimage2]),
              "I DJ at Beghain every other Friday, happy to share some tricks",
              DateTime(2021, 08, 10, 10, 11))
        ]));
    _myActivities.add(Activity(
        "Let's paint Barbies blue",
        "Why are all the Barbies pink? Let's paing them blue!",
        ["music", "techno", "learning"],
        this._user.person));

    notifyListeners();
  }
}
