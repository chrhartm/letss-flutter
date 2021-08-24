import 'dart:typed_data';

import 'package:flutter/services.dart';

class Person {
  String name;
  String bio;
  DateTime _dob;
  String job;
  String location;
  double longitude;
  double latitude;
  List<String> interests;
  List<Uint8List> pics;

  // Something wrong with this one
  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - this._dob.year;
    int month1 = currentDate.month;
    int month2 = this._dob.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = this._dob.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  set dob(DateTime dob) {
    this._dob = dob;
  }

  static Future<Person> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          Uint8List dummyimage =
              (await rootBundle.load('assets/images/dummy_avatar_1.jpeg'))
                  .buffer
                  .asUint8List();
          return Person(
              "Joe Juggler",
              "Just a juggler who is sick of circus. Not looking for dates, just friendship",
              DateTime(2000, 1, 1),
              "Cabin attendant at KLM",
              "5km from you",
              ["juggling", "riding", "friendship", "yourmom"],
              [dummyimage]);
        }
      case 2:
        {
          Uint8List dummyimage =
              (await rootBundle.load('assets/images/dummy_avatar_2.jpeg'))
                  .buffer
                  .asUint8List();
          return Person(
              "Betty Beautiful",
              "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
              DateTime(1998, 9, 10),
              "Candy shop owner",
              "Amsterdam Noord",
              ["dancing", "friendship", "dating", "riding", "volleyball"],
              [dummyimage]);
        }
      default:
        {
          Uint8List dummyimage =
              (await rootBundle.load('assets/images/dummy_avatar_3.jpeg'))
                  .buffer
                  .asUint8List();
          return Person(
              "Timmy Tester",
              "I just love testing everything. Apps, food, activities. I always have some star stickers on me in case there is no app to rate things.",
              DateTime(1700, 9, 9),
              "Michellin Restaurant Tester",
              "Closer than you think",
              ["testing", "food", "QA", "ratings"],
              [dummyimage]);
        }
    }
  }

  Person(this.name, this.bio, this._dob, this.job, this.location,
      this.interests, this.pics,
      {this.longitude = 0, this.latitude = 0});
}
