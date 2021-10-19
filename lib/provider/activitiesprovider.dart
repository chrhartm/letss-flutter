import 'dart:collection';
import 'package:flutter/material.dart';

import '../backend/activityservice.dart';
import '../models/activity.dart';
import '../backend/linkservice.dart';

class ActivitiesProvider extends ChangeNotifier {
  final List<Activity> _activities = [];
  String status = "LOADING";

  ActivitiesProvider() {
    getMore();
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
    if (_activities.isEmpty) {
      getMore();
    }
    notifyListeners();
  }

  void getMore() async {
    _activities.addAll(await ActivityService.getActivities());
    if (_activities.length == 0) {
      this.status = "EMPTY";
    } else {
      this.status = "OK";
    }
    notifyListeners();
  }
}
