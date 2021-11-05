import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' as convert_lib;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;

import 'package:letss_app/backend/userservice.dart';
import 'package:letss_app/screens/widgets/other/dummyimage.dart';
import 'category.dart';
import 'package:letss_app/theme/theme.dart';

class Person {
  String uid;
  String name;
  String bio;
  DateTime dob;
  String job;
  String gender;
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

  Map<String, dynamic> toJson({bool datestring = false}) => {
        'name': name,
        'bio': bio,
        'dob': datestring ? dob.toString() : dob,
        'job': job,
        'gender': gender,
        'interests': interests.map((e) => e.name).toList(),
        'profilePicURL': profilePicURL,
        'thumbnail': _thumbnailData == null ? null : _thumbnailData.toString(),
        'location': location,
      };
  Person.fromJson(
      {required String uid,
      required Map<String, dynamic> json,
      bool datestring = false})
      : uid = uid,
        name = json['name'],
        bio = json['bio'],
        gender = json['gender'],
        dob = datestring ? DateTime.parse(json['dob']) : json['dob'].toDate(),
        job = json['job'],
        interests = List.from(json['interests'])
            .map((e) => Category.fromString(name: e))
            .toList(),
        profilePicURL =
            json['profilePicURL'] == null ? "" : json['profilePicURL'],
        _thumbnailData = json['thumbnail'] == null
            ? null
            : Uint8List.fromList(
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
      return CachedNetworkImage(
          imageUrl: profilePicURL,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Scaffold(),
          errorWidget: (context, url, error) => DummyImage(),
          fadeInDuration: const Duration(milliseconds: 100),
          fadeOutDuration: const Duration(milliseconds: 0),
          imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover))));
    }
    return DummyImage();
  }

  String get locationString {
    if (location == null ||
        ((location!["subLocality"] == null) &&
            (location!["locality"] == null))) {
      return "";
    }
    // show city here
    if (location!["subLocality"] == "") {
      return location!["locality"];
    } else {
      return location!["subLocality"];
    }
  }

  Person({
    required this.uid,
    required this.name,
    required this.bio,
    required this.dob,
    required this.gender,
    required this.job,
    required this.interests,
    this.profilePicURL = "",
    this.supporter = false,
  });

  Person.emptyPerson({String name = ""})
      : this.uid = "",
        this.name = name,
        this.bio = "",
        this.gender = "",
        this.job = "",
        this.dob = DateTime.now(),
        this.interests = [],
        this.profilePicURL = "",
        this.supporter = false;
}
