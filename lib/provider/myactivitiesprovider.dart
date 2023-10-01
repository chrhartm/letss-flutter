import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/genericconfigservice.dart';
import 'package:letss_app/backend/templateservice.dart';

import '../models/message.dart';
import '../models/category.dart';
import '../models/person.dart';
import '../models/searchparameters.dart';
import '../models/template.dart';
import '../provider/userprovider.dart';
import '../models/activity.dart';
import '../models/like.dart';
import '../models/chat.dart';
import '../backend/activityservice.dart';
import '../backend/chatservice.dart';
import 'followerprovider.dart';

class MyActivitiesProvider extends ChangeNotifier {
  late List<Activity> _myActivities;
  late Map<String, bool> _collapsed;
  late UserProvider _user;
  late Activity newActivity;
  late SearchParameters _ideaSearchParameters;
  late List<String> _ideas;
  late bool _ideasInitialised;
  late bool _generatingIdeas;
  final _random = new Random();

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
    _ideaSearchParameters =
        SearchParameters(locality: "NONE", language: Locale("en"));
    List<dynamic> rawIdeas =
        GenericConfigService.getJson("welcome_activities")["activities"];
    _ideas = rawIdeas.map((e) => e.toString()).toList();
    _ideasInitialised = false;
    _generatingIdeas = false;
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
    newActivity = Activity.emptyActivity(_user.user.person);
    Navigator.pushNamed(context, '/myactivities/activity/editname');
  }

  void editActivityFromTemplate(BuildContext context, Template template) {
    editActiviyUid = null;
    newActivity =
        Activity.fromTemplate(template: template, person: _user.user.person);
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

  Future<Activity> updateActivity(
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
      activity.personData = activity.person.activityPersonData;
      if (editActiviyUid != null || activity.isComplete()) {
        await ActivityService.setActivity(activity);
      }
      if (editActiviyUid == null && activity.isComplete()) {
        // Add at beginning since list ordered by timestmap
        _myActivities.insert(0, activity);
        _collapsed[activity.uid] = false;
        editActiviyUid = activity.uid;
      }
      notifyListeners();
    }
    return activity;
  }

  void passLike({required Like like}) {
    like.status = "PASSED";
    ActivityService.updateLike(like: like);
    notifyListeners();
  }

  void confirmLike({required Activity activity, required Like like}) async {
    like.status = 'LIKED';
    ActivityService.updateLike(like: like);
    if (activity.participants.any((p) => p.uid == like.person.uid)) {
      return;
    }
    activity.participants.add(like.person);
    await ActivityService.setActivity(activity);
    Chat chat = await ChatService.joinActivityChat(
        activity: activity, person: like.person);
    DateTime now = DateTime.now();
    if (like.hasMessage) {
      ChatService.sendMessage(
          chat: chat,
          message: Message(
              message: like.message!,
              userId: like.person.uid,
              timestamp: now.add(const Duration(seconds: 2))));
    }
    FollowerProvider.amFollowing(like.person).then((amFollowing) {
      if (!amFollowing) {
        FollowerProvider.follow(person: like.person, trigger: "ADD");
      }
    });
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
      empty = true;
    } else {
      empty = false;
    }

    notifyListeners();
  }

  set ideaSearchParameters(SearchParameters searchParameters) {
    _ideaSearchParameters = searchParameters;
    notifyListeners();
  }

  SearchParameters get ideaSearchParameters {
    return _ideaSearchParameters;
  }

  Future<List<Template>> searchTemplates() {
    return TemplateService.searchTemplates(_ideaSearchParameters);
  }

  void _generateIdeas() async {
    if (_generatingIdeas) {
      return;
    }
    _generatingIdeas = true;
    List<Template> templates =
        await TemplateService.searchTemplates(_ideaSearchParameters, N: 200);
    _ideas = (templates.map((e) => e.name)).toList();
    _ideasInitialised = true;
    _generatingIdeas = false;
  }

  String getIdea(Locale language) {
    if (((_user.user.person.location != null &&
            (_user.user.person.location!['locality'] !=
                _ideaSearchParameters.locality))) ||
        (_ideasInitialised == false)) {
      _ideaSearchParameters = SearchParameters(
          locality: _user.user.person.location!['locality'],
          language: _ideaSearchParameters.language);
      if (_ideaSearchParameters.language == null ||
          _ideaSearchParameters.language!.countryCode != language.countryCode) {
        _ideaSearchParameters = SearchParameters(
            locality: _ideaSearchParameters.locality, language: language);
      }
      _generateIdeas();
    }
    int index = _random.nextInt(_ideas.length);
    String idea = _ideas.elementAt(index);
    if (_ideas.length <= 10) {
      _generateIdeas();
    } else {
      _ideas.removeAt(index);
    }
    newActivity.description = "";
    newActivity.categories = [];
    return idea;
  }

  bool isOwner({required Activity activity}) {
    return (activity.person.uid == _user.user.person.uid);
  }

  void removeParticipant({required Activity activity, required Person person}) {
    activity.participants.removeWhere((p) => p.uid == person.uid);
    ActivityService.setActivity(activity);
    ChatService.removeUserFromActivityChat(
        activityId: activity.uid, userId: person.uid);
    // needed double because can be eg triggered from chat where activity
    // not from here
    _myActivities
        .firstWhere((a) => a.uid == activity.uid)
        .participants
        .removeWhere((p) => p.uid == person.uid);
    notifyListeners();
  }

  void addParticipant({required Activity activity, required Person person}) {
    activity.participants.add(person);
    ActivityService.setActivity(activity);
    ChatService.joinActivityChat(activity: activity, person: person);
    if (!_myActivities
        .firstWhere((a) => a.uid == activity.uid)
        .hasParticipant(person)) {
      _myActivities
          .firstWhere((a) => a.uid == activity.uid)
          .participants
          .add(person);
    }
    notifyListeners();
  }
}
