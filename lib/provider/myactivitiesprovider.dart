import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/backend/templateservice.dart';

import '../models/message.dart';
import '../models/category.dart';
import '../models/searchparameters.dart';
import '../models/template.dart';
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
  late SearchParameters _searchParameters;

  bool empty = false;
  String? editActiviyUid;
  late Map<String, Stream<Iterable<Like>>> _likeStreams;

  MyActivitiesProvider(UserProvider user) {
    this._user = user;
    clearData();
    init();
    this._user.addListener(_onUserChanged);
  }

  _onUserChanged() {
    newActivity.person = _user.user.person;
    _myActivities.forEach((act) {
      act.person = _user.user.person;
    });
  }

  void clearData() {
    _myActivities = [];
    _collapsed = {};
    newActivity = Activity.emptyActivity(_user.user.person);
    editActiviyUid = null;
    _likeStreams = {};
    _searchParameters = SearchParameters(locality: "NONE");
  }

  void collapse(Activity activity) {
    _collapsed[activity.uid] = !_collapsed[activity.uid]!;
    notifyListeners();
  }

  void init() {
    // Duplicate with clearData b/c also called when _user is not null
    newActivity = Activity.emptyActivity(_user.user.person);
    if (_myActivities.length == 0 && _user.user.person.uid != "") {
      loadMyActivities();
    }
  }

  UnmodifiableListView<Activity> get myActivities {
    // Hack because sometimes data gets lost when force-closing app
    LoggerService.log("$empty");
    if (_myActivities.length == 0 && !empty && _user.user.person.uid != "") {
      loadMyActivities();
    }
    return UnmodifiableListView(_myActivities);
  }

  Future archive(Activity activity) async {
    editActiviyUid = activity.uid;
    await updateActivity(status: 'ARCHIVED');
    _myActivities.removeWhere((act) => act.uid == activity.uid);
    _likeStreams.remove(activity.uid);
    _collapsed.remove(activity.uid);
    editActiviyUid = null;
    resetStreams();
    notifyListeners();
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

  // Ugly hack but somehow necessary after archive
  void resetStreams() {
    _myActivities.forEach((act) {
      _likeStreams[act.uid] = ActivityService.streamMyLikes(act);
    });
  }

  void addNewActivity(BuildContext context) {
    editActiviyUid = null;
    Navigator.pushNamed(context, '/myactivities/activity/editname');
  }

  void editActivityFromTemplate(BuildContext context, Template template){
    editActiviyUid = null;
    newActivity = Activity.fromTemplate(template: template, person: _user.user.person);
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
      activity.location = _user.user.person.location;
      activity.personData = activity.person.metaData;
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
    if (_user.user.person.uid == "") {
      return;
    }
    this._myActivities =
        await ActivityService.getMyActivities(this._user.user.person);
    this._collapsed = {};
    for (int i = 0; i < this._myActivities.length; i++) {
      this._collapsed[_myActivities[i].uid] = false;
    }
    if (_myActivities.length == 0) {
      LoggerService.log(
          "got empty activities for user ${_user.user.person.uid}");
      empty = true;
    } else {
      empty = false;
    }

    notifyListeners();
  }

  void set searchParameters(SearchParameters searchParameters) {
    _searchParameters = searchParameters;
    notifyListeners();
  }

  SearchParameters get searchParameters {
    return _searchParameters;
  }

  Future<List<Template>> searchTemplates() {
    return TemplateService.searchTemplates(_searchParameters);
  }
}
