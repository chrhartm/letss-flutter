import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' as convert_lib;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;

import '../backend/userservice.dart';
import '../Widgets/dummyimage.dart';
import 'category.dart';
import '../backend/loggerservice.dart';
import '../theme/theme.dart';

class Person {
  String uid;
  String name;
  String bio;
  DateTime dob;
  String job;
  bool supporter;
  List<Category> interests;
  String profilePicURL;
  Uint8List? _thumbnailData;
  Map<String, dynamic>? location;

  bool isComplete() {
    if (this.name == "" ||
        this.bio == "" ||
        this.interests.length == 0 ||
        this.profilePicURL == "" ||
        this._thumbnailData == null ||
        this.job == "" ||
        this.age > 200 ||
        this.uid == "") {
      return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bio': bio,
        'dob': dob,
        'job': job,
        'interests': interests.map((e) => e.name).toList(),
        'profilePicURL': profilePicURL,
        'thumbnail': _thumbnailData.toString(),
        'location': location,
      };
  Person.fromJson({required String uid, required Map<String, dynamic> json})
      : uid = uid,
        name = json['name'],
        bio = json['bio'],
        dob = json['dob'].toDate(),
        job = json['job'],
        interests = List.from(json['interests'])
            .map((e) => Category.fromString(name: e))
            .toList(),
        profilePicURL = json['profilePicURL'],
        _thumbnailData = Uint8List.fromList(
            convert_lib.json.decode(json['thumbnail']).cast<int>()),
        location = json['location'],
        // Doing check in case it's null
        supporter = json['supporter'] == true;

  int get age {
    return calculateAge(this.dob);
  }

  static int calculateAge(DateTime dob) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dob.year;
    int month1 = currentDate.month;
    int month2 = dob.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = dob.day;
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
      return CircleAvatar(
          backgroundImage: image,
          backgroundColor: apptheme.colorScheme.primary);
    } else {
      return CircleAvatar(backgroundColor: apptheme.colorScheme.primary);
    }
  }

  Widget get profilePic {
    if (this.profilePicURL != "") {
      return Image.network(profilePicURL,
          errorBuilder: (context, exception, stackTrace) {
        logger.w("Could not load image: $profilePicURL");
        return DummyImage();
      }, fit: BoxFit.cover);
    }
    return DummyImage();
  }

  String get locationString {
    if (location == null || location!["subLocality"] == null) {
      return "";
    }
    // show city here
    return location!["subLocality"];
  }

  Person({
    required this.uid,
    required this.name,
    required this.bio,
    required this.dob,
    required this.job,
    required this.interests,
    this.profilePicURL = "",
    this.supporter = false,
  });

  Person.emptyPerson({String name = ""})
      : this.uid = "",
        this.name = name,
        this.bio = "",
        this.job = "",
        this.dob = DateTime.now(),
        this.interests = [],
        this.profilePicURL = "",
        this.supporter = false;
}
