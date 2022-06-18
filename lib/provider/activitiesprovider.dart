import 'dart:collection';
import 'package:flutter/material.dart';
import '../backend/activityservice.dart';
import '../backend/remoteconfigservice.dart';
import '../models/activity.dart';
import '../backend/linkservice.dart';
import '../models/searchparameters.dart';
import '../provider/userprovider.dart';

class ActivitiesProvider extends ChangeNotifier {
  late List<Activity> _activities;
  late List<String> _likedActivities;
  late String status;
  late UserProvider _user;
  late DateTime lastCheck;
  late Duration checkDuration;
  late int maxCardsBeforeNew;
  late SearchParameters _searchParameters;
  bool promptShown = true;
  bool gettingActivities = false;
  int _nReloads = 0;
  int checkSeconds = 10;

  ActivitiesProvider(UserProvider user) {
    clearData();
    _user = user;
  }

  void init() {
    _likedActivities = [];
    getMore();
  }

  void clearData() {
    _activities = [];
    _likedActivities = [];
    status = "OK";
    lastCheck = DateTime(2000, 1, 1);
    checkDuration = Duration(seconds: checkSeconds);
    maxCardsBeforeNew = 3;
    promptShown = true;
    _nReloads = 0;
    _searchParameters = SearchParameters(locality: "NONE");
  }

  UnmodifiableListView<Activity> get activities {
    return UnmodifiableListView(_activities);
  }

  void share(Activity activity) {
    LinkService.shareActivity(activity: activity, mine: false);
  }

  void promptPass() async {
    promptShown = true;
    gettingActivities = true;
    notifyListeners();
    await getMore();
    notifyListeners();
    await Future.delayed(Duration(seconds: checkSeconds));
    gettingActivities = false;
    notifyListeners();
  }

  bool get showPrompt {
    int mod =
        RemoteConfigService.remoteConfig.getInt("activityAddPromptEveryTenX");
    return _nReloads % mod == 0;
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

  void getMoreIfNeeded() {
    if (_activities.length < maxCardsBeforeNew) {
      if (!showPrompt) {
        getMore();
      }
    }
  }

  void pass(Activity activity) {
    ActivityService.pass(activity);
    _activities.removeWhere((act) => act.uid == activity.uid);
    notifyListeners();
    getMoreIfNeeded();
  }

  Future like({required Activity activity, required String message}) async {
    // Wait for like to finish because otherwise same activity added again
    _activities.removeWhere((act) => act.uid == activity.uid);
    _likedActivities.add(activity.uid);
    _user.user.coins -= 1;
    notifyListeners();
    getMoreIfNeeded();
    await ActivityService.like(activity: activity, message: message);
  }

  Future resetAfterLocationChange() async {
    clearData();
    return ActivityService.generateMatches().then((value) => value==true?getMore():null);
  }

  Future getMore() async {
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
          if (!_likedActivities.contains(activity.uid) &&
              !_activities.any((a) => a.uid == activity.uid)) {
            _activities.add(activity);
          }
        }
        // Super hacky, get a proper data structure next time
        const maxLength = 50;
        if (_likedActivities.length > maxLength) {
          _likedActivities.removeRange(0, _likedActivities.length - maxLength);
        }

        if (_activities.length == 0) {
          this.status = "EMPTY";
        } else {
          this._nReloads += 1;
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
