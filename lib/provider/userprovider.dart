import 'package:flutter/material.dart';
import '../models/person.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User user = User(Person("", "", DateTime(0, 1, 1), "", "", [], []));

  UserProvider() {
    loadPerson();
  }

  void update(
      {String? name,
      String? job,
      String? bio,
      DateTime? dob,
      double? latitude,
      double? longitude}) {
    if (name != null) {
      user.person.name = name;
    }
    if (job != null) {
      user.person.job = job;
    }
    if (bio != null) {
      user.person.bio = bio;
    }
    if (dob != null) {
      user.person.dob = dob;
    }
    if (latitude != null) {
      user.person.latitude = latitude;
    }
    if (longitude != null) {
      user.person.longitude = longitude;
    }

    notifyListeners();
  }

  void loadPerson() async {
    this.user.person = await Person.getDummy(3);

    notifyListeners();
  }
}
