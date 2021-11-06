import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';

import '../models/message.dart';
import '../models/category.dart';
import '../provider/userprovider.dart';
import '../models/activity.dart';
import '../models/like.dart';
import '../models/chat.dart';
import '../backend/activityservice.dart';
import '../backend/chatservice.dart';

class MyActivitiesProvider extends ChangeNotifier {
  late List<Activity> _myActivities;
  late Map<String, bool> _collapsed;
  late UserProvider _user;
  late Activity newActivity;
  String? editActiviyUid;
  late Map<String, Stream<Iterable<Like>>> _likeStreams;

  MyActivitiesProvider(UserProvider user) {
    this._user = user;
    clearData();
    init();
  }

  void clearData() {
    _myActivities = [];
    _collapsed = {};
    newActivity = Activity.emptyActivity(_user.user.person);
    editActiviyUid = null;
    _likeStreams = {};
  }

  void collapse(Activity activity) {
    _collapsed[activity.uid] = !_collapsed[activity.uid]!;
    notifyListeners();
  }

  void init() {
    // Duplicate with clearData b/c also called when _user is not null
    newActivity = Activity.emptyActivity(_user.user.person);
    if (_myActivities.length == 0) {
      loadMyActivities();
    }
  }

  UnmodifiableListView<Activity> get myActivities {
    return UnmodifiableListView(_myActivities);
  }

  bool isCollapsed(activity) {
    return (_collapsed[activity.uid] == true);
  }

  Stream<Iterable<Like>> likeStream(Activity activity) {
    if (_likeStreams.containsKey(activity.uid) == false) {
      _likeStreams[activity.uid] = ActivityService.streamMyLikes(activity);
    }
    return _likeStreams[activity.uid]!;
  }

  void addNewActivity(BuildContext context) {
    editActiviyUid = null;
    analytics.logEvent(name: "Activity_Add");
    Navigator.pushNamed(context, '/myactivities/activity/editname');
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

  Future updateActivity(
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
        // Add at beginning since list ordered by timestmap
        _myActivities.insert(0, activity);
        _collapsed[activity.uid] = false;
        newActivity = Activity.emptyActivity(activity.person);
      }
      notifyListeners();
    }
  }

  void updateLike(
      {required Activity activity,
      required Like like,
      required String status}) async {
    like.status = status;
    ActivityService.updateLike(like: like);
    if (status == 'LIKED') {
      Chat chat = await ChatService.startChat(person: like.person);
      DateTime now = DateTime.now();
      ChatService.sendMessage(
          chat: chat,
          message: Message(
              message: activity.name,
              userId: _user.user.person.uid,
              timestamp: now));
      ChatService.sendMessage(
          chat: chat,
          message: Message(
              message: activity.description,
              userId: _user.user.person.uid,
              timestamp: now.add(const Duration(seconds: 1))));
      ChatService.sendMessage(
          chat: chat,
          message: Message(
              message: like.message,
              userId: like.person.uid,
              timestamp: now.add(const Duration(seconds: 2))));
    }

    notifyListeners();
  }

  void loadMyActivities() async {
    this._myActivities =
        await ActivityService.getMyActivities(this._user.user.person);
    this._collapsed = {};
    for (int i = 0; i < this._myActivities.length; i++) {
      this._collapsed[_myActivities[i].uid] = false;
    }

    notifyListeners();
  }
}
