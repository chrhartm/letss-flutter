import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/activityservice.dart';
import '../models/activity.dart';

class ActivitiesProvider extends ChangeNotifier {
  final List<Activity> _activities = [];

  ActivitiesProvider() {
    getMore();
  }

  UnmodifiableListView<Activity> get activities {
    return UnmodifiableListView(_activities);
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
    notifyListeners();
  }
}
