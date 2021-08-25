import 'dart:io';
import 'package:flutter/material.dart';

import '../Widgets/dummyimage.dart';

class Person {
  String name;
  String bio;
  DateTime dob;
  String job;
  String location;
  double longitude;
  double latitude;
  List<String> interests;
  File? picture;

  // Something wrong with this one
  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - this.dob.year;
    int month1 = currentDate.month;
    int month2 = this.dob.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = this.dob.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Widget get profilePic {
    if (this.picture != null) {
      return Image.file(picture!, fit: BoxFit.cover);
    }
    return DummyImage();
  }

  static Future<Person> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          return Person(
              "Joe Juggler",
              "Just a juggler who is sick of circus. Not looking for dates, just friendship",
              DateTime(2000, 1, 1),
              "Cabin attendant at KLM",
              "5km from you",
              ["juggling", "riding", "friendship", "yourmom"]);
        }
      case 2:
        {
          return Person(
              "Betty Beautiful",
              "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
              DateTime(1998, 9, 10),
              "Candy shop owner",
              "Amsterdam Noord",
              ["dancing", "friendship", "dating", "riding", "volleyball"]);
        }
      default:
        {
          return Person(
              "Timmy Tester",
              "I just love testing everything. Apps, food, activities. I always have some star stickers on me in case there is no app to rate things.",
              DateTime(1900, 9, 9),
              "Michellin Restaurant Tester",
              "Closer than you think",
              ["testing", "food", "QA", "ratings"]);
        }
    }
  }

  Person(this.name, this.bio, this.dob, this.job, this.location, this.interests,
      {this.longitude = 0, this.latitude = 0, this.picture});
}
