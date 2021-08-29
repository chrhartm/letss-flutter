import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' as convert_lib;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;
import 'package:letss_app/backend/userservice.dart';
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
  String profilePicURL;
  Uint8List? _thumbnailData;

  bool isComplete() {
    if (this.name == "" ||
        this.bio == "" ||
        this.interests == [] ||
        this.profilePicURL == "" ||
        this._thumbnailData == null ||
        this.latitude == 0 ||
        this.longitude == 0 ||
        this.job == "" ||
        this.age > 200) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bio': bio,
        'dob': dob,
        'job': job,
        'latitude': latitude,
        'longitude': longitude,
        'interests': interests.map((e) => e.name).toList(),
        'profilePicURL': profilePicURL,
        'thumbnail': thumbnail.toString()
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
            .toList(),
        profilePicURL = json['profilePicURL'],
        _thumbnailData = Uint8List.fromList(convert_lib.json
            .decode(json['thumbnail'])
            .cast<int>()); //json['thumbnail']);

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

  Future<bool> updateProfilePic(File profilePic) async {
    final image = image_lib.decodeImage(profilePic.readAsBytesSync())!;
    profilePic.deleteSync();
    final imageResized = image_lib.copyResizeCropSquare(image, 1080);
    final imageThumbnail = image_lib.copyResize(imageResized, width: 100);
    this._thumbnailData =
        Uint8List.fromList(image_lib.encodePng(imageThumbnail));
    profilePic.writeAsBytesSync(image_lib.encodeJpg(imageResized));
    this.profilePicURL = await UserService.uploadImage(profilePic);
    // returning value so that other function can wait for this to finish
    return true;
  }

  Widget get thumbnail {
    ImageProvider image;
    if (_thumbnailData != null) {
      image = MemoryImage(_thumbnailData!);
    }
    image = NetworkImage(
        'https://firebasestorage.googleapis.com/v0/b/letss-11cc7.appspot.com/o/profilePics%2FcDVr9xdUVtMj7F9XaOVsAyKUXyu1.jpg?alt=media&token=81a4395f-c89b-49b9-a0cc-bb586278c82c');
    return CircleAvatar(backgroundImage: image);
  }

  Widget get profilePic {
    if (this.profilePicURL != "") {
      return Image.network(profilePicURL, fit: BoxFit.cover);
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
            ],
          );
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
            ],
          );
        }
    }
  }

  Person({
    required this.uid,
    required this.name,
    required this.bio,
    required this.dob,
    required this.job,
    required this.interests,
    this.longitude = 0,
    this.latitude = 0,
    this.profilePicURL = "",
  });
}
