import 'package:flutter/material.dart';
import 'package:letss_app/provider/followerprovider.dart';
import 'package:share_plus/share_plus.dart';
import '../backend/activityservice.dart';
import '../models/activity.dart';
import '../backend/linkservice.dart';
import '../models/searchparameters.dart';
import '../provider/userprovider.dart';

class ActivitiesProvider extends ChangeNotifier {
  late UserProvider _user;
  late SearchParameters _searchParameters;

  ActivitiesProvider(UserProvider user) {
    clearData();
    _user = user;
  }

  void init() {}

  void clearData() {
    _searchParameters = SearchParameters(locality: "NONE");
  }

  Future<ShareResult> share(Activity activity) async {
    return LinkService.shareActivity(activity: activity, mine: false);
  }

  Future<void> downloadAndShareImage(Activity activity) async {
    return LinkService.downloadAndShareImage(activity);
  }

  Future like({required Activity activity, required String message}) async {
    _user.user.coins -= 1;
    notifyListeners();
    await ActivityService.like(activity: activity, message: message);
    FollowerProvider.amFollowing(activity.person).then((amFollowing) {
      if (!amFollowing) {
        FollowerProvider.follow(person: activity.person, trigger: "LIKE");
      }
    });
  }

  Future resetAfterLocationChange() async {
    clearData();
    _searchParameters =
        SearchParameters(locality: _user.user.person.location!.locality);
  }

  set searchParameters(SearchParameters searchParameters) {
    _searchParameters = searchParameters;
    notifyListeners();
  }

  SearchParameters get searchParameters {
    return _searchParameters;
  }

  Future<List<Activity>> searchActivities() async {
    List<Activity> myActivities = [];
    if (_searchParameters.category == null) {
      myActivities =
          (await ActivityService.streamActivities(person: _user.user.person)
                  .first)
              .toList()
              .reversed
              .toList();
    }
    myActivities
        .addAll(await ActivityService.searchActivities(_searchParameters));
    return myActivities;
  }
}
