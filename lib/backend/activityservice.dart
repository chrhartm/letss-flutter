import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:letss_app/backend/personservice.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:letss_app/models/searchparameters.dart';
import '../models/activity.dart';
import '../models/like.dart';
import '../models/user.dart';
import '../models/person.dart';
import '../models/category.dart';
import '../backend/loggerservice.dart';

class ActivityService {
  static Future setActivity(Activity activity) async {
    if (activity.uid == "") {
      activity.timestamp = DateTime.now();
      await FirebaseFirestore.instance
          .collection('activities')
          .add(activity.toJson())
          .then((doc) {
        activity.uid = doc.id;
      });
    } else {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(activity.uid)
          .update(activity.toJson());
    }
  }

  static Future<Activity> getActivity(String uid) async {
    Map<String, dynamic> activityData = {};
    await FirebaseFirestore.instance
        .collection('activities')
        .doc(uid)
        .get()
        .then((DocumentSnapshot activity) {
      activityData = activity.data() as Map<String, dynamic>;
      activityData["uid"] = activity.id;
    });
    Person? person = await PersonService.getPerson(uid: activityData["user"]);
    return Activity.fromJson(json: activityData, person: person);
  }

  static void pass(Activity activity) {
    String matchId = activity.matchId(
        userId: firebase_auth.FirebaseAuth.instance.currentUser!.uid);
    _setStatusWithMatchId(matchId, status: "PASS");
  }

  static void breakMatch(Activity activity) {
    String matchId = activity.matchId(
        userId: firebase_auth.FirebaseAuth.instance.currentUser!.uid);
    _setStatusWithMatchId(matchId, status: "BROKEN");
  }

  static void _setStatusWithMatchId(String matchId, {String status = "PASS"}) {
    try {
      FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .update({'status': status});
    } catch (error) {
      LoggerService.log("Couldn't update matches (eg from dynamic link)");
    }
  }

  static Future like(
      {required Activity activity, required String message}) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1").httpsCallable(
      'activity-like',
    );

    try {
      final results = await callable.call({
        "activityId": activity.uid,
        "activityUserId": activity.person.uid,
        "message": message
      });
      LoggerService.log(results.toString());
      LoggerService.log('${results.data}');
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log("Failed to submit like\n${results.data}", level: "e");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err when trying to like", level: "e");
    }
  }

  static void updateLike({required Like like}) {
    FirebaseFirestore.instance
        .collection('activities')
        .doc(like.activityId)
        .collection('likes')
        .doc(like.person.uid)
        .update({'status': like.status, 'read': like.read});
  }

  static void markLikeRead(Like like) {
    if (like.read == false) {
      like.read = true;
      updateLike(like: like);
    }
  }

  static Future<List<Activity>> getMyActivities(Person person) async {
    String uid = person.uid;
    List<Activity> activities = [];
    if (firebase_auth.FirebaseAuth.instance.currentUser == null ||
        firebase_auth.FirebaseAuth.instance.currentUser!.uid != uid) {
      return activities;
    }
    await FirebaseFirestore.instance
        .collection('activities')
        .where('user', isEqualTo: uid)
        .where('status', isEqualTo: 'ACTIVE')
        .orderBy('timestamp')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        jsonData["uid"] = doc.id;
        Activity act = Activity.fromJson(json: jsonData, person: person);
        activities.add(act);
      });
    });

    return List.from(activities.reversed);
  }

  static Future<List<Activity>> getActivities(User user) async {
    List<String> activityIds = [];
    List<Map<String, dynamic>> activityJsons = [];
    List<Activity> activities = [];

    String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('matches')
        .where('user', isEqualTo: userId)
        .where('status', isEqualTo: 'NEW')
        .where('location.locality',
            isEqualTo: user.person.location!["locality"])
        .limit(10) //needed for wherein later
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        activityIds.add(jsonData['activity']);
      });
    });

    if (activityIds.length > 0) {
      await FirebaseFirestore.instance
          .collection('activities')
          .where(FieldPath.documentId, whereIn: activityIds)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
          jsonData["uid"] = doc.id;
          activityJsons.add(jsonData);
          activityIds.remove(doc.id);
        });
      });

      // Needed to trigger new activity generation
      if (activityIds.length > 0) {
        activityIds.forEach((actId) =>
            _setStatusWithMatchId("${actId}_${userId}", status: "BROKEN"));
      }

      for (int i = 0; i < activityJsons.length; i++) {
        Person person =
            await PersonService.getPerson(uid: activityJsons[i]['user']);
        Activity act =
            Activity.fromJson(json: activityJsons[i], person: person);
        if (activityJsons[i]["status"] == "ACTIVE" &&
            // ugly hack
            person.name != "Person not found") {
          activities.add(act);
        } else {
          breakMatch(act);
        }
      }
    }

    // Already generate some more when not needed yet
    if (activities.length < 10) {
      generateMatches().then((value) async {
        if (value == true) {
          try {
            return await getActivities(user);
          } catch (error) {
            LoggerService.log("Couldn't load activities\n$error");
          }
        }
      });

      return activities;
    }

    return activities;
  }

  static Future<bool> generateMatches() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('activity-generateMatches');
    try {
      final results = await callable();
      LoggerService.log('${results.data}');
      if (results.data["code"] == 200) {
        return true;
      }
    } catch (err) {
      LoggerService.log("Couldn't generate more activities\n$err", level: "e");
    }
    return false;
  }

  // Duplicate logic with above but can't merge due to pass logic
  static Future<List<Activity>> activitiesFromJsons(
      List<Map<String, dynamic>> activityJsons) async {
    List<Activity> activities = [];
    for (int i = 0; i < activityJsons.length; i++) {
      Person person =
          await PersonService.getPerson(uid: activityJsons[i]['user']);
      Activity act = Activity.fromJson(json: activityJsons[i], person: person);
      activities.add(act);
    }
    return activities;
  }

  static Stream<Iterable<Like>> streamMyLikes(Activity activity) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.uid)
        .collection('likes')
        .where('status', isEqualTo: 'ACTIVE')
        .orderBy('timestamp')
        .limit(10)
        .snapshots()
        .asyncMap((QuerySnapshot list) =>
            Future.wait(list.docs.map((DocumentSnapshot snap) async {
              Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
              Person person = await PersonService.getPerson(uid: snap.id);
              return Like.fromJson(
                  json: data, person: person, activityId: activity.uid);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Error in getting likes\n$e", level: "e");
    });
  }

  static Stream<Iterable<Activity>> streamActivities({required Person person}) {
    return FirebaseFirestore.instance
        .collection('activities')
        .where('user', isEqualTo: person.uid)
        .where('status', isEqualTo: 'ACTIVE')
        .orderBy('timestamp')
        .snapshots()
        .asyncMap((QuerySnapshot list) =>
            Future.wait(list.docs.map((DocumentSnapshot snap) async {
              Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
              data["uid"] = snap.id;
              return Activity.fromJson(json: data, person: person);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Error in streaming activities with error $e",
          level: "e");
    });
  }

  static Future<List<Activity>> searchActivities(
      SearchParameters searchParameters) async {
    List<Map<String, dynamic>> activityJsons = [];
    List<String> likedActivities = [];

    // first get all liked activities
    String userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('matches')
        .where('user', isEqualTo: userId)
        .where('status', isEqualTo: 'LIKE')
        .where('location.locality', isEqualTo: searchParameters.locality)
        .orderBy("timestamp", descending: true)
        .limit(1000)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        likedActivities.add(jsonData['activity']);
      });
    });

    Query query = FirebaseFirestore.instance
        .collection('activities')
        .where('status', isEqualTo: 'ACTIVE')
        .where('location.locality', isEqualTo: searchParameters.locality);

    if (searchParameters.category != null) {
      query = query.where('categories',
          arrayContains: searchParameters.category!.name);
    }
    await query
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        if (jsonData['user'] != userId && !likedActivities.contains(doc.id)) {
          jsonData["uid"] = doc.id;
          activityJsons.add(jsonData);
        }
      });
    });
    return activitiesFromJsons(activityJsons);
  }

  static Future<List<Category>> Function(String) getCategoriesByCountry(
      {required String isoCountryCode}) {
    return ((String query) =>
        _getCategories(query: query, isoCountryCode: isoCountryCode));
  }

  static Future<List<Category>> _getCategories(
      {required String query, required String isoCountryCode}) async {
    List<Category> categories = [];
    Query dataQuery = FirebaseFirestore.instance
        .collection('categories')
        .doc(isoCountryCode)
        .collection('categories')
        // Cannot order by popularity due to firestore limitation
        .where('status', isEqualTo: 'ACTIVE');
    if (query.length > 0) {
      dataQuery = dataQuery.where('name',
          isGreaterThanOrEqualTo: query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(query.codeUnitAt(query.length - 1) + 1));
    }
    await dataQuery.limit(1000).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        categories.add(Category.fromJson(json: data));
      });
    }).catchError((error) {
      LoggerService.log("Failed to get categories\n$error", level: "e");
    });

    // This is a workaround
    // Firebase doesn't support text search and orderby popularity at same time
    // So first download all relevant categories, then order by popularity
    categories.sort((a, b) => b.popularity.compareTo(a.popularity));
    return categories;
  }

  static void addCategory(
      {required Category category, required String isoCountryCode}) async {
    if (category.status == 'REQUESTED') {
      FirebaseFirestore.instance
          .collection('categories')
          .doc(isoCountryCode)
          .collection('categories')
          .doc(category.name)
          .set(category.toJson(), SetOptions(merge: true))
          .then((value) => LoggerService.log(
              "Added in $isoCountryCode: " + category.toJson().toString()))
          .catchError((error) => {});
    }
  }
}
