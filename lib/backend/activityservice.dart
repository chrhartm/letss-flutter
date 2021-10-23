import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letss_app/backend/userservice.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../models/activity.dart';
import '../models/like.dart';
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
    });
    Person? person = await UserService.getPerson(uid: activityData["user"]);
    return Activity.fromJson(uid: uid, json: activityData, person: person!);
  }

  static void pass(Activity activity) {
    try {
      FirebaseFirestore.instance
          .collection('matches')
          .doc(activity.matchId)
          .update({'status': 'PASS'});
    } catch (error) {
      logger.d("Couldn't update matches (eg from dynamic link)");
    }
  }

  static void like(
      {required Activity activity, required String message}) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1").httpsCallable(
      'activity-like',
    );

    try {
      final results = await callable.call({
        "activityId": activity.uid,
        "matchId": activity.uid + "_" + FirebaseAuth.instance.currentUser!.uid,
        "activityUserId": activity.person.uid,
        "message": message
      });
      logger.d(results);
      logger.d('${results.data}');
      if (results.data["code"] == 200) {
        return;
      } else {
        logger.w("Tried to like, didn't get 200 but ${results.data}");
      }
    } catch (err) {
      logger.e("Caught error: $err when trying to like");
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

  static Future<List<Activity>> getMyActivities(Person user) async {
    List<Activity> activities = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('activities')
        .where('user', isEqualTo: uid)
        .where('status', isEqualTo: 'ACTIVE')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        Activity act =
            Activity.fromJson(uid: doc.id, json: jsonData, person: user);
        activities.add(act);
      });
    });

    return activities;
  }

  static Future<List<Activity>> getActivities() async {
    List<String> activityIds = [];
    List<String> matchIds = [];
    List<Map<String, dynamic>> activityJsons = [];
    List<Activity> activities = [];

    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('matches')
        .where('user', isEqualTo: uid)
        .where('status', isEqualTo: 'NEW')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        activityIds.add(jsonData['activity']);
        matchIds.add(doc.id);
      });
    });

    if (activityIds.length == 0) {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: "europe-west1")
              .httpsCallable('activity-generateMatches');

      try {
        final results = await callable();
        logger.d('${results.data}');
        if (results.data["code"] == 200) {
          return await getActivities();
        }
      } catch (err) {
        logger.e("Caught error: $err in activityservice");
      }

      return activities;
    }

    await FirebaseFirestore.instance
        .collection('activities')
        .where(FieldPath.documentId, whereIn: activityIds)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
        activityJsons.add(jsonData);
      });
    });

    for (int i = 0; i < activityJsons.length; i++) {
      Person? person =
          await UserService.getPerson(uid: activityJsons[i]['user']);
      if (person != null) {
        activities.add(Activity.fromJson(
            uid: activityIds[i], json: activityJsons[i], person: person));
        activities[i].matchId = matchIds[i];
      }
    }

    return activities;
  }

  static Stream<Iterable<Like>> streamMyLikes(Activity activity) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.uid)
        .collection('likes')
        .where('status', isEqualTo: 'ACTIVE')
        // TODO order by something
        //.orderBy('lastMessage.timestamp')
        .snapshots()
        .asyncMap((QuerySnapshot list) =>
            Future.wait(list.docs.map((DocumentSnapshot snap) async {
              Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
              Person? person = await UserService.getPerson(uid: snap.id);
              return Like.fromJson(
                  json: data, person: person!, activityId: activity.uid);
            })))
        .handleError((dynamic e) {
      logger.e("Error in chatservice with error $e");
    });
  }

  static Future<List<Category>> Function(String) getCategoriesByCountry(
      {required String isoCountryCode}) {
    return ((String query) =>
        _getCategories(query: query, isoCountryCode: isoCountryCode));
  }

  static Future<List<Category>> _getCategories(
      {required String query, required String isoCountryCode}) async {
    List<Category> categories = [];
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(isoCountryCode)
        .collection('categories')
        // Cannot order by popularity due to firestore limitation
        .where('status', isEqualTo: 'ACTIVE')
        .where('name',
            isGreaterThanOrEqualTo: query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .limit(1000)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        categories.add(Category.fromJson(json: data));
      });
    }).catchError((error) {
      logger.e("Failed to get categories: $error");
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
          .set(category.toJson())
          .then((value) => logger
              .i("Added in $isoCountryCode: " + category.toJson().toString()))
          .catchError((error) => logger.e("Failed to add activity: $error"));
    }
  }
}
