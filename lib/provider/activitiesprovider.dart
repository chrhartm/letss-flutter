import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivitiesProvider extends ChangeNotifier {
  final List<Activity> _activities = [];

  ActivitiesProvider() {
    getMore();
  }

  UnmodifiableListView<Activity> get activities {
    if (_activities.isEmpty) {
      getMore();
    }
    return UnmodifiableListView(_activities);
  }

  void like() {
    _activities.removeLast();
    notifyListeners();

    if (_activities.isEmpty) {
      getMore();
    }
  }

  void getMore() async {
    _activities.add(await Activity.getDummy(1));
    _activities.add(await Activity.getDummy(2));

    notifyListeners();
  }
}
