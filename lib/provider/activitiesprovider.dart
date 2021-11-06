import 'dart:collection';
import 'package:flutter/material.dart';

import '../backend/activityservice.dart';
import '../models/activity.dart';
import '../backend/linkservice.dart';
import '../provider/userprovider.dart';

class ActivitiesProvider extends ChangeNotifier {
  late List<Activity> _activities;
  late String status;
  late UserProvider _user;
  late DateTime lastCheck;
  late Duration checkDuration;
  late int maxCardsBeforeNew;

  ActivitiesProvider(UserProvider user) {
    clearData();
    _user = user;
    if (_user.initialized) {
      getMore();
    }
  }

  void init() {
    getMore();
  }

  void clearData() {
    _activities = [];
    status = "OK";
    lastCheck = DateTime(2000, 1, 1);
    checkDuration = Duration(minutes: 5);
    maxCardsBeforeNew = 3;
  }

  UnmodifiableListView<Activity> get activities {
    return UnmodifiableListView(_activities);
  }

  void share(Activity activity) {
    LinkService.shareActivity(activity: activity, mine: false);
  }

  void add(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void pass(Activity activity) {
    ActivityService.pass(activity);
    _activities.removeWhere((act) => act.uid == activity.uid);
    if (_activities.isEmpty) {
      getMore();
    }
    notifyListeners();
  }

  Future like({required Activity activity, required String message}) async {
    // Wait for like to finish because otherwise same activity added again
    _activities.removeWhere((act) => act.uid == activity.uid);
    _user.user.coins -= 1;
    notifyListeners();
    await ActivityService.like(activity: activity, message: message);
    if (_activities.isEmpty) {
      getMore();
    }
  }

  void getMore() async {
    if (_activities.length < maxCardsBeforeNew) {
      DateTime now = DateTime.now();
      if (now.difference(lastCheck) > checkDuration) {
        lastCheck = now;
        _activities.addAll(await ActivityService.getActivities());
        if (_activities.length == 0) {
          this.status = "EMPTY";
        } else {
          this.status = "OK";
        }
        notifyListeners();
      } else if (_activities.length == 0) {
        this.status = "EMPTY";
      }
    }
  }
}
