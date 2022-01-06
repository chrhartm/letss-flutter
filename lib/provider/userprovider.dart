import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/backend/storeservice.dart';
import 'package:letss_app/models/subscription.dart';

import '../models/person.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../backend/userservice.dart';
import '../backend/locationservice.dart';
import '../backend/loggerservice.dart';

class UserProvider extends ChangeNotifier {
  User user = User(Person.emptyPerson());
  bool initialized = false;
  bool personLoaded = false;
  bool userLoaded = false;

  UserProvider() {}

  void clearData() {
    user = User(Person.emptyPerson());
    initialized = false;
    personLoaded = false;
  }

  bool completedSignup() {
    return user.person.isComplete();
  }

  void logout() async {
    await UserService.logout();
    notifyListeners();
  }

  Future delete() async {
    clearData();
    await UserService.delete();
  }

  void markReviewRequested() {
    this.user.requestedReview = true;
    UserService.markReviewRequeted();
  }

  void markSupportRequested() {
    LoggerService.log("Mark Support Requested");
    this.user.requestedSupport = true;
    UserService.markSupportRequested();
  }

  void deleteProfilePic(String name) async {
    await user.person.deleteProfilePic(name);
    PersonService.updatePerson(user.person);
    user.person.cleanUrls();
    notifyListeners();
  }

  void forceNotify() {
    notifyListeners();
  }

  Future switchPics(int a, int b) async {
    await user.person.switchPics(a, b);
    PersonService.updatePerson(user.person);
    notifyListeners();
  }

  Future updatePerson(
      {String? name,
      String? job,
      String? bio,
      String? gender,
      DateTime? dob,
      double? latitude,
      double? longitude,
      List<Category>? interests,
      List<Object>? profilePic}) async {
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
    if (gender != null && gender != user.person.gender) {
      user.person.gender = gender;
      updated = true;
    }
    if ((latitude != null) && (longitude != null)) {
      user.person.location = await LocationService.generateLocation(
          latitude: latitude, longitude: longitude);
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
      await PersonService.updatePerson(user.person);
      notifyListeners();
    }
  }

  void initUserPerson() {
    if (initialized == false) {
      initialized = true;
      LoggerService.setUserIdentifier(this.user.person.uid);
      notifyListeners();
    }
  }

  void loadUser() {
    loadPerson();
    if (!userLoaded) {
      UserService.streamUser().listen((user) {
        if (user != null) {
          if (user["coins"] != null) {
            this.user.coins = user['coins'];
          }
          if (user["requestedReview"] != null) {
            this.user.requestedReview = true;
          }
          if (user["lastOnline"] == null ||
              DateTime.now()
                  .subtract(Duration(days: 1))
                  .isAfter(user["lastOnline"].toDate())) {
            UserService.updateLastOnline();
          }
          if (user["subscription"] != null) {
            this.user.subscription =
                Subscription.fromJson(json: user['subscription']);
            if (DateTime.now()
                .subtract(Duration(days: 32))
                .isAfter(this.user.subscription.timestamp)) {
              StoreService.cancelSubscription()
                  .then((val) => StoreService().restorePurchases());
            }
          }
          if (DateTime.now()
              .subtract(Duration(days: 7))
              .isAfter(user["lastSupportRequest"].toDate())) {
            this.user.requestedSupport = false;
          }
          userLoaded = true;
        }
        notifyListeners();
      }).onError((err) {
        // Nothing for now
      });
    }
  }

  void loadPerson() {
    if (!personLoaded) {
      PersonService.streamPerson().listen((person) {
        if (person != null) {
          this.user.person = person;
          personLoaded = true;
          initUserPerson();
        }
      }).onError((err) {
        // User doesn't exist yet
        user.person.uid = auth.FirebaseAuth.instance.currentUser!.uid;
        initUserPerson();
      });
    }
  }
}
