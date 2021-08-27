import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../provider/userprovider.dart';
import '../models/activity.dart';

class LikesProvider extends ChangeNotifier {
  late List<Activity> _myActivities;
  late UserProvider _user;
  late Activity newActivity;
  int? editActiviyIndex;

  UnmodifiableListView<Activity> get myActivities {
    return UnmodifiableListView(_myActivities);
  }

  Activity get editActivity {
    return editActiviyIndex == null
        ? newActivity
        : _myActivities[editActiviyIndex!];
  }

  LikesProvider(UserProvider user) {
    this._myActivities = [];
    this._user = user;
    this.newActivity = Activity(
        categories: [], person: user.user.person, name: "", description: "");
    loadMyActivities();
  }

  void updateActivity(
      {String? name, String? description, List<Category>? categories}) {
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
    if (updated == true) {
      if (editActiviyIndex == null &&
          activity.name != "" &&
          newActivity.description != "" &&
          newActivity.categories.length > 0) {
        print("add new activity");
        newActivity = Activity(
            categories: [],
            description: "",
            name: "",
            person: newActivity.person);
      }
      print("reload my activities");

      notifyListeners();
    }
  }

  void loadMyActivities() async {
    this
        ._myActivities
        .add(await Activity.getMyDummy(1, this._user.user.person));
    this
        ._myActivities
        .add(await Activity.getMyDummy(2, this._user.user.person));

    notifyListeners();
  }
}
