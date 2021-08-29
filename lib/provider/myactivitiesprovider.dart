import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../provider/userprovider.dart';
import '../models/activity.dart';
import '../backend/activityservice.dart';

class MyActivitiesProvider extends ChangeNotifier {
  late List<Activity> _myActivities;
  late UserProvider _user;
  late Activity newActivity;
  String? editActiviyUid;

  UnmodifiableListView<Activity> get myActivities {
    return UnmodifiableListView(_myActivities);
  }

  Activity get editActivity {
    if (editActiviyUid == null) {
      return newActivity;
    } else {
      for (int i = 0; i < _myActivities.length; i++) {
        if (_myActivities[i].uid == editActiviyUid) {
          return _myActivities[i];
        }
      }
    }
    return newActivity;
  }

  MyActivitiesProvider(UserProvider user) {
    this._myActivities = [];
    this._user = user;
    this.newActivity = Activity.emptyActivity(user.user.person);
    loadMyActivities();
  }

  void updateActivity(
      {String? name,
      String? description,
      List<Category>? categories,
      String? status}) async {
    Activity activity = this.editActivity;
    bool updated = false;
    if (name != null && name != activity.name) {
      activity.name = name;
      updated = true;
    }
    if (categories != null && categories != activity.categories) {
      activity.categories = categories;
      updated = true;
    }
    if (description != null && description != activity.description) {
      activity.description = description;
      updated = true;
    }
    if (status != null && status != activity.status) {
      activity.status = status;
      updated = true;
    }
    if (updated == true) {
      if (editActiviyUid != null || activity.isComplete()) {
        await ActivityService.setActivity(activity);
      }
      if (editActiviyUid == null && activity.isComplete()) {
        _myActivities.add(activity);
        newActivity = Activity.emptyActivity(activity.person);
      }

      notifyListeners();
    }
  }

  void loadMyActivities() async {
    this._myActivities =
        await ActivityService.getMyActivities(this._user.user.person);

    notifyListeners();
  }
}
