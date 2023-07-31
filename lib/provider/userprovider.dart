import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/backend/storeservice.dart';
import 'package:letss_app/models/subscription.dart';

import '../models/person.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../backend/userservice.dart';
import '../backend/locationservice.dart';
import '../backend/loggerservice.dart';
import '../screens/widgets/dialogs/restoresubscriptiondialog.dart';
import 'followerprovider.dart';

class UserProvider extends ChangeNotifier {
  User user = User(Person.emptyPerson());
  bool initialized = false;
  bool personLoaded = false;
  bool userLoaded = false;
  StreamSubscription? usersubscription = null;
  StreamSubscription? personsubscription = null;

  UserProvider() {}

  void clearData() {
    user = User(Person.emptyPerson());
    initialized = false;
    personLoaded = false;
    userLoaded = false;
    if (usersubscription != null) {
      usersubscription!.cancel();
      usersubscription = null;
    }
    if (personsubscription != null) {
      personsubscription!.cancel();
      personsubscription = null;
    }
  }

  bool get searchEnabled {
    int searchDays = ConfigService.config.searchDays;
    return (user.person.badge != "" ||
        DateTime.now()
            .subtract(Duration(days: searchDays))
            .isBefore(user.dateRegistered) ||
        this.user.config["featureSearch"] == true);
  }

  bool completedSignup() {
    return user.person.isComplete();
  }

  void logout() async {
    await UserService.logout();
    clearData();
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

  void markNotificationsRequested() {
    LoggerService.log("Mark Notifications Requested");
    this.user.requestedNotifications = true;
    UserService.markNotificationsRequested();
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
      int? age,
      double? latitude,
      double? longitude,
      List<Category>? interests,
      List<Object>? profilePic,
      BuildContext? context}) async {
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
    if (age != null && age != user.person.age) {
      user.person.age = age;
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
      ConfigService.reload_config();
      notifyListeners();
    }
  }

  void initUserPerson() {
    if (personLoaded == true && userLoaded == true && initialized == false) {
      initialized = true;
      LoggerService.setUserIdentifier(this.user.person.uid);
      notifyListeners();
    }
  }

  void loadUser(BuildContext context) {
    loadPerson();
    if (!userLoaded) {
      usersubscription = UserService.streamUser().listen((user) {
        if (user != null) {
          bool notify = false;
          if (user.containsKey("coins")) {
            this.user.coins = user['coins'];
          }
          if (user.containsKey("config")) {
            this.user.config = user['config'];
          }
          if (user.containsKey("status")) {
            this.user.status = user['status'];
            if (this.user.status != "ACTIVE") {
              notify = true;
              LoggerService.log(
                "User is not active. Contact support@letss.app.",
                level: "e",
              );
            }
          }
          if (user.containsKey("dateRegistered")) {
            DateTime oldDate = this.user.dateRegistered;
            DateTime newDate = user["dateRegistered"].toDate();
            if (oldDate.compareTo(newDate) != 0) {
              this.user.dateRegistered = newDate;
              notify = true;
            }
          }
          if (user.containsKey("requestedReview")) {
            if (this.user.requestedReview == false) {
              notify = true;
              this.user.requestedReview = true;
            }
          }
          if (!user.containsKey("lastOnline") ||
              DateTime.now()
                  .subtract(Duration(days: 1))
                  .isAfter(user["lastOnline"].toDate())) {
            UserService.updateLastOnline();
          }
          if (user.containsKey("subscription")) {
            Subscription subscription =
                Subscription.fromJson(json: user['subscription']);
            if (this.user.subscription.productId != subscription.productId) {
              notify = true;
            }
            this.user.subscription = subscription;

            if (DateTime.now()
                    .subtract(Duration(days: 32))
                    .isAfter(this.user.subscription.timestamp) &&
                this.user.subscription.productId != "none") {
              StoreService.cancelSubscription().then((val) => showDialog(
                  context: context,
                  builder: (context) {
                    return RestoreSubscriptionDialog();
                  }));
            }
          }
          if (!user.containsKey("lastSupportRequest") ||
              DateTime.now()
                  .subtract(Duration(
                      days: ConfigService.config.supportRequestInterval))
                  .isAfter(user["lastSupportRequest"].toDate())) {
            if (this.user.requestedSupport) {
              notify = true;
              this.user.requestedSupport = false;
            }
          }
          if (!user.containsKey("lastNotificationsRequest") ||
              DateTime.now()
                  .subtract(Duration(
                      days: ConfigService.config.notificationsRequestInterval))
                  .isAfter(user["lastNotificationsRequest"].toDate())) {
            if (this.user.requestedNotifications) {
              notify = true;
              this.user.requestedNotifications = false;
            }
          }
          if (!userLoaded) {
            notify = true;
            userLoaded = true;
            initUserPerson();
          }
          if (notify) {
            notifyListeners();
          }
        }
      });
      usersubscription!.onError((err) {
        LoggerService.log("Error loading user\n$err", level: "w");
        // Nothing for now
      });
    }
  }

  void loadPerson() {
    if (!personLoaded) {
      personsubscription = PersonService.streamPerson().listen((person) {
        if (person != null) {
          this.user.person = person;
          personLoaded = true;
          initUserPerson();
        }
      });
      personsubscription!.onError((err) {
        // User doesn't exist yet
        user.person.uid = auth.FirebaseAuth.instance.currentUser!.uid;
        personLoaded = true;
        initUserPerson();
      });
    }
  }

  static void blockUser(Person person) {
    UserService.blockUser(person.uid);
    FollowerProvider.unfollow(person: person);
  }

  static Future<bool> blockedMe(Person person) {
    return UserService.blockedMe(person.uid);
  }
}
