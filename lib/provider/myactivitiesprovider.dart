import 'dart:collection';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../models/category.dart';
import '../provider/userprovider.dart';
import '../models/activity.dart';
import '../models/like.dart';
import '../models/chat.dart';
import '../backend/activityservice.dart';
import '../backend/chatservice.dart';

class MyActivitiesProvider extends ChangeNotifier {
  late List<Activity>? _myActivities;
  late UserProvider _user;
  late Activity newActivity;
  String? editActiviyUid;
  late Map<String, Stream<Iterable<Like>>> _likeStreams;

  MyActivitiesProvider(UserProvider user) {
    this._user = user;
    clearData();
  }

  void clearData() {
    _myActivities = [];
    newActivity = Activity.emptyActivity(_user.user.person);
    editActiviyUid = null;
    _likeStreams = {};
  }

  void init() {
    if (_myActivities == null) {
      loadMyActivities();
    }
  }

  UnmodifiableListView<Activity> get myActivities {
    return UnmodifiableListView(_myActivities!);
  }

  Stream<Iterable<Like>> likeStream(Activity activity) {
    if (_likeStreams.containsKey(activity.uid) == false) {
      _likeStreams[activity.uid] = ActivityService.streamMyLikes(activity);
    }
    return _likeStreams[activity.uid]!;
  }

  Activity get editActivity {
    if (editActiviyUid == null) {
      return newActivity;
    } else {
      for (int i = 0; i < _myActivities!.length; i++) {
        if (_myActivities![i].uid == editActiviyUid) {
          return _myActivities![i];
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
        _myActivities!.add(activity);
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

    notifyListeners();
  }
}
