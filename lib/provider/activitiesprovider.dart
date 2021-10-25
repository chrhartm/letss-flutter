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
    status = "LOADING";
    lastCheck = DateTime(2000, 1, 1);
    checkDuration = Duration(minutes: 5);
    maxCardsBeforeNew = 3;
  }

  UnmodifiableListView<Activity> get activities {
    return UnmodifiableListView(_activities);
  }

  void share() {
    LinkService.shareActivity(activity: _activities.last, mine: false);
  }

  void add(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void pass() {
    ActivityService.pass(_activities.last);
    _activities.removeLast();
    if (_activities.isEmpty) {
      getMore();
    }
    notifyListeners();
  }

  void like(String message) {
    ActivityService.like(activity: _activities.last, message: message);
    _activities.removeLast();
    _user.user.coins -= 1;
    if (_activities.isEmpty) {
      getMore();
    }
    notifyListeners();
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
