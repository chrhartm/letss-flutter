import 'dart:collection';
import 'package:flutter/material.dart';

import '../backend/activityservice.dart';
import '../models/activity.dart';
import '../backend/linkservice.dart';
import '../models/searchparameters.dart';
import '../provider/userprovider.dart';

class ActivitiesProvider extends ChangeNotifier {
  late List<Activity> _activities;
  late List<String> _recentActivities;
  late String status;
  late UserProvider _user;
  late DateTime lastCheck;
  late Duration checkDuration;
  late int maxCardsBeforeNew;
  late SearchParameters _searchParameters;

  ActivitiesProvider(UserProvider user) {
    clearData();
    _user = user;
    _recentActivities = [];
    if (_user.initialized) {
      getMore();
    }
  }

  void init() {
    _recentActivities = [];
    getMore();
  }

  void clearData() {
    _activities = [];
    _recentActivities = [];
    status = "OK";
    lastCheck = DateTime(2000, 1, 1);
    checkDuration = Duration(minutes: 5);
    maxCardsBeforeNew = 3;
    _searchParameters = SearchParameters(locality: "NONE");
  }

  UnmodifiableListView<Activity> get activities {
    return UnmodifiableListView(_activities);
  }

  void share(Activity activity) {
    LinkService.shareActivity(activity: activity, mine: false);
  }

  void addTop(Activity activity) {
    if (_activities.any((a) => a.uid == activity.uid)) {
      _activities.remove(activity);
    }
    _activities.insert(0, activity);
    if (status == "EMPTY") {
      status = "OK";
    }
    notifyListeners();
  }

  void pass(Activity activity) {
    ActivityService.pass(activity);
    _activities.removeWhere((act) => act.uid == activity.uid);
    _recentActivities.add(activity.uid);
    if (_activities.isEmpty) {
      getMore();
    }
    notifyListeners();
  }

  Future like({required Activity activity, required String message}) async {
    // Wait for like to finish because otherwise same activity added again
    _activities.removeWhere((act) => act.uid == activity.uid);
    _recentActivities.add(activity.uid);
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
      if (this.status != "EMPTY" ||
          (now.difference(lastCheck) > checkDuration)) {
        lastCheck = now;
        List<Activity> activities = await ActivityService.getActivities();
        // Rearrange list so that the same person never follows each other
        activities.shuffle();
        for (int i = 0; i < activities.length - 1; i++) {
          if (activities[i].person.uid == activities[i + 1].person.uid) {
            activities.add(activities[i + 1]);
            activities.removeAt(i + 1);
          }
        }
        // Due to async, can get activities that were already passed/liked
        // but not updated yet
        for (Activity activity in activities) {
          if (!_recentActivities.contains(activity.uid) &&
              !_activities.any((a) => a.uid == activity.uid)) {
            _activities.add(activity);
          }
        }
        // Super hacky, get a proper data structure next time
        const maxLength = 50;
        if (_recentActivities.length > maxLength) {
          _recentActivities.removeRange(
              0, _recentActivities.length - maxLength);
        }

        if (_activities.length == 0) {
          this.status = "EMPTY";
        } else {
          this.status = "OK";
        }
        notifyListeners();
      } else {
        // LoggerService.log("ActivitiesProvide getMore No more activities");
      }
    }
  }

  void set searchParameters(SearchParameters searchParameters) {
    _searchParameters = searchParameters;
    notifyListeners();
  }

  SearchParameters get searchParameters {
    return _searchParameters;
  }

  Future<List<Activity>> searchActivities() {
    return ActivityService.searchActivities(_searchParameters);
  }
}
