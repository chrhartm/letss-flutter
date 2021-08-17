import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import '../models/activity.dart';

class LikesProvider extends ChangeNotifier {
  List<Activity> _myActivities = [];
  UserProvider _user = UserProvider();

  UnmodifiableListView<Activity> get myActivities {
    return UnmodifiableListView(_myActivities);
  }

  LikesProvider(UserProvider user) {
    this._user = user;
    loadMyActivities();
  }

  void loadMyActivities() async {
    this._myActivities.add(await Activity.getMyDummy(1, this._user.person));
    this._myActivities.add(await Activity.getMyDummy(2, this._user.person));

    notifyListeners();
  }
}
