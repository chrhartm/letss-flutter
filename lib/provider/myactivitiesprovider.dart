import 'dart:math';
import 'package:flutter/material.dart';
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
  late UserProvider _user;
  late Activity editActivity;
  late SearchParameters _ideaSearchParameters;
  late List<String> _ideas;
  late bool _ideasInitialised;
  late bool _generatingIdeas;
  final _random = Random();

  bool empty = false;

  MyActivitiesProvider(UserProvider user) {
    _user = user;
    clearData();
    init();
    _user.addListener(_onUserChanged);
  }

  _onUserChanged() {
    editActivity.person = _user.user.person;
  }

  void clearData() {
    editActivity = Activity.emptyActivity(_user.user.person);
    _ideaSearchParameters =
        SearchParameters(locality: "NONE", language: Locale("en"));
    _ideas = [];
    _ideasInitialised = false;
    _generatingIdeas = false;
  }

  void init() {
    // Duplicate with clearData b/c also called when _user is not null
    editActivity = Activity.emptyActivity(_user.user.person);
  }

  Future archive(Activity activity) async {
    await updateActivity(status: 'ARCHIVED');
    notifyListeners();
  }

  void addNewActivity(BuildContext context) {
    editActivity = Activity.emptyActivity(_user.user.person);
    Navigator.pushNamed(context, '/myactivities/activity/editname');
  }

  void editActivityFromTemplate(BuildContext context, Template template) {
    editActivity =
        Activity.fromTemplate(template: template, person: _user.user.person);
    Navigator.pushNamed(context, '/myactivities/activity/editname');
  }

  Future<Activity> updateActivity(
      {String? name,
      String? description,
      List<Category>? categories,
      String? status}) async {
    Activity activity = editActivity;
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
      if (activity.isComplete()) {
        await ActivityService.setActivity(activity);
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

  void confirmLike(
      {required Activity activity,
      required Like like,
      required String welcomeMessage}) async {
    like.status = 'LIKED';
    ActivityService.updateLike(like: like);
    if (activity.participants.any((p) => p.uid == like.person.uid)) {
      return;
    }
    activity.participants.add(like.person);
    await ActivityService.setActivity(activity);
    Chat chat = await ChatService.joinActivityChat(
        activity: activity,
        person: like.person,
        welcomeMessage: like.hasMessage ? null : welcomeMessage);
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

  set ideaSearchParameters(SearchParameters searchParameters) {
    _ideaSearchParameters = searchParameters;
    notifyListeners();
  }

  SearchParameters get ideaSearchParameters {
    return _ideaSearchParameters;
  }

  Future<List<Template>> searchTemplates({bool withGeneric = true}) {
    return TemplateService.searchTemplates(_ideaSearchParameters,
        withGeneric: withGeneric);
  }

  void _generateIdeas() async {
    if (_generatingIdeas) {
      return;
    }
    _generatingIdeas = true;
    List<Template> templates = await TemplateService.searchTemplates(
        _ideaSearchParameters,
        N: 200,
        withGeneric: !_user.user.person.location!.isVirtual);
    _ideas = (templates.map((e) => e.name)).toList();
    _ideasInitialised = true;
    _generatingIdeas = false;
  }

  String getIdea(Locale language) {
    if ((_ideasInitialised == false) ||
        ((_user.user.person.location != null &&
            (_user.user.person.location!.locality !=
                _ideaSearchParameters.locality))) ||
        (_ideaSearchParameters.language == null ||
            (_ideaSearchParameters.language!.languageCode !=
                language.languageCode))) {
      _ideaSearchParameters = SearchParameters(
          locality: _user.user.person.location == null
              ? "NONE"
              : _user.user.person.location!.locality,
          language: language);
      _generateIdeas();
    }

    if (_ideas.isEmpty) {
      return "";
    }

    int index = _random.nextInt(_ideas.length);
    String idea = _ideas.elementAt(index);
    if (_ideas.length <= 10) {
      _generateIdeas();
    } else {
      _ideas.removeAt(index);
    }
    editActivity.description = "";
    editActivity.categories = [];
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
    notifyListeners();
  }

  void addParticipant(
      {required Activity activity,
      required Person person,
      required String welcomeMessage}) {
    activity.participants.add(person);
    ActivityService.setActivity(activity);
    ChatService.joinActivityChat(
        activity: activity, person: person, welcomeMessage: welcomeMessage);
    notifyListeners();
  }

  Future<void> gotoChat(BuildContext context, Activity activity) {
    String chatId =
        ChatService.generateActivityChatId(activityId: activity.uid);

    return ChatService.getChat(chatId: chatId).then((chat) {
      if (context.mounted) {
        Navigator.pushNamed(context, '/chats/chat', arguments: chat);
      }
    });
  }
}
