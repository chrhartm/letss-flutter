import 'dart:io';
import 'package:flutter/material.dart';

import '../Widgets/dummyimage.dart';
import 'category.dart';

class Person {
  String uid;
  String name;
  String bio;
  DateTime dob;
  String job;
  double longitude;
  double latitude;
  List<Category> interests;
  File? picture;

  Map<String, dynamic> toJson() => {
        'name': name,
        'bio': bio,
        'dob': dob,
        'job': job,
        'latitude': latitude,
        'longitude': longitude,
        'interests': interests.map((e) => e.name).toList()
      };
  Person.fromJson(String uid, Map<String, dynamic> json)
      : uid = uid,
        name = json['name'],
        bio = json['bio'],
        dob = json['dob'].toDate(),
        job = json['job'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        interests = List.from(json['interests'])
            .map((e) => Category(name: e, popularity: 1))
            .toList();

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

  String get location {
    return "some location";
  }

  static Future<Person> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          return Person(
              uid: "789",
              name: "Joe Juggler",
              bio:
                  "Just a juggler who is sick of circus. Not looking for dates, just friendship",
              dob: DateTime(2000, 1, 1),
              job: "Cabin attendant at KLM",
              interests: [
                Category(name: "juggling", popularity: 0.2),
                Category(name: "riding", popularity: 0.1),
                Category(name: "friendship", popularity: 0.8),
                Category(name: "yourmom", popularity: 0)
              ]);
        }
      case 2:
        {
          return Person(
              uid: "456",
              name: "Betty Beautiful",
              bio:
                  "Accountant by day, 60's gal by night. Looking for boys and girls for dates and friendship :peace:",
              dob: DateTime(1998, 9, 10),
              job: "Candy shop owner",
              interests: [
                Category(name: "dancing", popularity: 0.5),
                Category(name: "friendship", popularity: 0.8),
                Category(name: "dating", popularity: 0.7),
                Category(name: "riding", popularity: 0.1),
                Category(name: "volleyball", popularity: 0.2)
              ]);
        }
      default:
        {
          return Person(
              uid: "123",
              name: "Timmy Tester",
              bio:
                  "I just love testing everything. Apps, food, activities. I always have some star stickers on me in case there is no app to rate things.",
              dob: DateTime(1900, 9, 9),
              job: "Michellin Restaurant Tester",
              interests: [
                Category(name: "testing", popularity: 0.1),
                Category(name: "food", popularity: 0.95),
                Category(name: "QA", popularity: 0.01),
                Category(name: "ratings", popularity: 0.01)
              ]);
        }
    }
  }

  Person(
      {required this.uid,
      required this.name,
      required this.bio,
      required this.dob,
      required this.job,
      required this.interests,
      this.longitude = 0,
      this.latitude = 0,
      this.picture});
}
