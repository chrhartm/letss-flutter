import 'dart:io';

import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/user.dart';
import '../models/category.dart';

class UserProvider extends ChangeNotifier {
  User user = User(Person(
      name: "", bio: "", dob: DateTime(0, 1, 1), job: "", interests: []));

  UserProvider() {
    loadPerson();
  }

  bool completedSignup() {
    if (user.person.name == "" ||
        user.person.bio == "" ||
        user.person.interests == [] ||
        user.person.picture == null ||
        user.person.latitude == 0 ||
        user.person.longitude == 0 ||
        user.person.job == "" ||
        user.person.age > 200) {
      return false;
    }
    return true;
  }

  void update(
      {String? name,
      String? job,
      String? bio,
      DateTime? dob,
      double? latitude,
      double? longitude,
      List<Category>? interests,
      File? profilePic}) {
    bool updated = false;

    if (name != null && name != user.person.name) {
      user.person.name = name;
      updated = true;
    }
    if (job != null && job != user.person.job) {
      user.person.job = job;
      updated = true;
    }
    if (bio != null && bio != user.person.bio) {
      user.person.bio = bio;
      updated = true;
    }
    if (dob != null && dob != user.person.dob) {
      user.person.dob = dob;
      updated = true;
    }
    if (latitude != null && latitude != user.person.latitude) {
      user.person.latitude = latitude;
      updated = true;
    }
    if (longitude != null && longitude != user.person.longitude) {
      user.person.longitude = longitude;
      updated = true;
    }
    if (interests != null) {
      user.person.interests = interests;
      updated = true;
    }
    if (profilePic != null) {
      user.person.picture = profilePic;
    }

    if (updated) {
      print("update database");
    }

    notifyListeners();
  }

  void loadPerson() async {
    this.user.person = await Person.getDummy(3);

    notifyListeners();
  }
}
