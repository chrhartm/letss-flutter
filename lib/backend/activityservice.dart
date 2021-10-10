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
  static Future<bool> setActivity(Activity activity) async {
    if (activity.uid == "") {
      activity.timestamp = DateTime.now();
      FirebaseFirestore.instance
          .collection('activities')
          .add(activity.toJson())
          .then((doc) {
        activity.uid = doc.id;
      });
    } else {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activity.uid)
          .update(activity.toJson());
    }
    return true;
  }

  static void pass(Activity activity) {
    FirebaseFirestore.instance
        .collection('matches')
        .doc(activity.matchId)
        .update({'status': 'PASS'});
  }

  static void like({required Activity activity, required String message}) {
    FirebaseFirestore.instance
        .collection('matches')
        .doc(activity.matchId)
        .update({'status': 'LIKE'});
    FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.uid)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(Like.jsonFromRaw(
            message: message, status: 'ACTIVE', timestamp: DateTime.now()));
  }

  static void updateLike(
      {required Activity activity,
      required Person person,
      required String status}) {
    FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.uid)
        .collection('likes')
        .doc(person.uid)
        .update({'status': status});
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

    for (int i = 0; i < activities.length; i++) {
      activities[i].likes = await getMyLikes(activities[i]);
    }

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
          FirebaseFunctions.instance.httpsCallable('generateMatches');

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
      Person? person = await UserService.getUser(uid: activityJsons[i]['user']);
      if (person != null) {
        activities.add(Activity.fromJson(
            uid: activityIds[i], json: activityJsons[i], person: person));
        activities[i].matchId = matchIds[i];
      }
    }

    return activities;
  }

  static Future<List<Like>> getMyLikes(Activity activity) async {
    List<Map<String, dynamic>> likeJsons = [];
    List<String> likePeople = [];
    List<Like> likes = [];
    await FirebaseFirestore.instance
        .collection('activities')
        .doc(activity.uid)
        .collection('likes')
        .where('status', isEqualTo: 'ACTIVE')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot doc) {
        Map<String, dynamic> jsonData = doc.data()! as Map<String, dynamic>;
        likeJsons.add(jsonData);
        likePeople.add(doc.id);
      });
    });
    for (int i = 0; i < likeJsons.length; i++) {
      Person? person = await UserService.getUser(uid: likePeople[i]);
      if (person != null) {
        likes.add(Like.fromJson(json: likeJsons[i], person: person));
      }
    }
    return likes;
  }

  static Future<List<Category>> getCategories(String query) async {
    List<Category> categories = [];
    await FirebaseFirestore.instance
        .collection('categories')
        // Cannot order by popularity due to firestore limitation
        .where('status', isEqualTo: 'ACTIVE')
        .where('name',
            isGreaterThanOrEqualTo: query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        categories.add(Category.fromJson(json: data));
      });
    }).catchError((error) {
      logger.e("Failed to get categories: $error");
    });
    return categories;
  }

  static void addCategory(Category category) async {
    if (category.status == 'REQUESTED') {
      FirebaseFirestore.instance
          .collection('categories')
          .doc(category.name)
          .set(category.toJson())
          .then((value) => logger.i("Added" + category.toJson().toString()))
          .catchError((error) => logger.e("Failed to add activity: $error"));
    }
  }
}
