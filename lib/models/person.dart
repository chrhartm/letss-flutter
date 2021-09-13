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
        location = json['location'];

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
    return CircleAvatar(
        backgroundImage: image, backgroundColor: Colors.grey[600]);
  }

  Widget get profilePic {
    if (this.profilePicURL != "") {
      return Image.network(profilePicURL, fit: BoxFit.cover);
    }
    return DummyImage();
  }

  String get locationString {
    // TODO update
    return "some location";
  }

  Person({
    required this.uid,
    required this.name,
    required this.bio,
    required this.dob,
    required this.job,
    required this.interests,
    this.profilePicURL = "",
  });

  Person.emptyPerson()
      : this.uid = "",
        this.name = "",
        this.bio = "",
        this.job = "",
        this.dob = DateTime(0, 1, 1),
        this.interests = [],
        this.profilePicURL = "";
}
