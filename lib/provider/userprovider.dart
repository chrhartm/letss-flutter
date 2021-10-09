import 'dart:io';
import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../backend/userservice.dart';

class UserProvider extends ChangeNotifier {
  User user = User(Person.emptyPerson());
  bool initialized = false;

  UserProvider() {
    loadPerson();
  }

  bool completedSignup() {
    return user.person.isComplete();
  }

  void logout() async {
    await UserService.logout();
    notifyListeners();
  }

  void delete() async {
    await UserService.delete();
    notifyListeners();
  }

  void update(
      {String? name,
      String? job,
      String? bio,
      DateTime? dob,
      double? latitude,
      double? longitude,
      List<Category>? interests,
      File? profilePic}) async {
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
    if ((latitude != null) &&
        (user.person.location != null) &&
        ((latitude != user.person.location!['geopoint'].latitude) ||
            longitude != user.person.location!['geopoint'].longitude)) {
      user.person.location = UserService.generateGeoHash(
          latitude: latitude, longitude: longitude!);
      updated = true;
    }
    if (interests != null) {
      user.person.interests = interests;
      updated = true;
    }
    if (profilePic != null) {
      await user.person.updateProfilePic(profilePic);
      updated = true;
    }

    if (updated) {
      UserService.setUser(user.person);
      notifyListeners();
    }
  }

  void loadPerson() async {
    Person? tmp = await UserService.getUser();

    if (tmp != null) {
      this.user.person = tmp;
      initialized = true;
      notifyListeners();
    }
  }
}
