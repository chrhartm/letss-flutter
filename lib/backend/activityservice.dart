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
    Map<String, dynamic> activityJson = activity.toJson();
    if (activity.uid == "") {
      activity.timestamp = DateTime.now();
      await FirebaseFirestore.instance
          .collection('activities')
          .add(activityJson)
          .then((doc) {
        activity.uid = doc.id;
      });
    } else {
      // Remove categories if empty so that they are not
      // overwritte when updating server-side
      if (!activity.hasCategories) {
        activityJson.remove('categories');
        LoggerService.log(activityJson.keys.toString());
      }
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(activity.uid)
          .update(activityJson);
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
    }).onError((error, stackTrace) {
      activityData["uid"] = "NOTFOUND";
    });
    if (activityData["uid"] == "NOTFOUND") {
      return Activity.emptyActivity(Person.emptyPerson());
    }
    Person person = await PersonService.getPerson(uid: activityData["user"]);
    List<Person> participants = [];
    if (activityData['participants'] != null &&
        activityData['participants'] is List) {
      participants = await ((Future.wait(activityData["participants"]
          .map<Future<Person>>((participant) async =>
              (await PersonService.getPerson(uid: participant)))
          .toList())));
    }
    return Activity.fromJson(
        json: activityData, person: person, participants: participants);
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

  static void _setStatusWithMatchId(String matchId,
      {String status = "PASS"}) async {
    try {
      await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .update({'status': status}).onError((error, stackTrace) =>
              LoggerService.log("Couldn't update match status"));
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
      await callable.call({
        "activityId": activity.uid,
        "activityUserId": activity.person.uid,
        "message": message
      });
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log(e.message!, level: "w");
    } catch (err) {
      LoggerService.log("Couldn't send like. Please try again.", level: "w");
    }
  }

  static void updateLike({required Like like}) {
    try {
      FirebaseFirestore.instance
          .collection('activities')
          .doc(like.activityId)
          .collection('likes')
          .doc(like.person.uid)
          .update({'status': like.status, 'read': like.read});
    } catch (error) {
      LoggerService.log("Couldn't update like");
    }
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
      LoggerService.log("no user in getMyActivities");
      return activities;
    }
    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('activities')
        .where('user', isEqualTo: uid)
        .where('status', isEqualTo: 'ACTIVE')
        .orderBy('timestamp')
        .get();

    await Future.forEach(querySnap.docs, (docRaw) async {
      QueryDocumentSnapshot<Object?> doc =
          docRaw as QueryDocumentSnapshot<Object?>;
      Map<String, dynamic> jsonData = doc.data() as Map<String, dynamic>;
      jsonData["uid"] = doc.id;
      List<Person> participants = [];
      if (jsonData['participants'] != null &&
          jsonData['participants'] is List) {
        participants = await Future.wait(jsonData["participants"]
            .map<Future<Person>>((participant) async =>
                await PersonService.getPerson(uid: participant))
            .toList());
      } else {
        jsonData["participants"] = [];
      }

      Activity act = Activity.fromJson(
          json: jsonData, person: person, participants: participants);
      activities.add(act);
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
            _setStatusWithMatchId("${actId}_$userId", status: "BROKEN"));
      }

      for (int i = 0; i < activityJsons.length; i++) {
        Person person =
            await PersonService.getPerson(uid: activityJsons[i]['user']);
        List<Person> participants = [];
        if (activityJsons[i]['participants'] != null &&
            activityJsons[i]['participants'] is List) {
          participants = await Future.wait(activityJsons[i]['participants']
              .map<Future<Person>>(
                  (p) async => await PersonService.getPerson(uid: p))
              .toList());
        }
        Activity act = Activity.fromJson(
            json: activityJsons[i], person: person, participants: participants);
        if (activityJsons[i]["status"] == "ACTIVE" &&
            // ugly hack
            person.name != "") {
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
      await callable();
      return true;
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log(e.message!, level: "i");
      return false;
    } catch (err) {
      LoggerService.log("Couldn't generate more activities\n$err", level: "i");
      return false;
    }
  }

  // Duplicate logic with above but can't merge due to pass logic
  static Future<List<Activity>> activitiesFromJsons(
      List<Map<String, dynamic>> activityJsons) async {
    List<Activity> activities = [];
    for (int i = 0; i < activityJsons.length; i++) {
      Person person =
          await PersonService.getPerson(uid: activityJsons[i]['user']);
      List<Person> participants = [];
      if (activityJsons[i]['participants'] != null &&
          activityJsons[i]['participants'] is List) {
        participants = await Future.wait(activityJsons[i]['participants']
            .map<Future<Person>>(
                (p) async => await PersonService.getPerson(uid: p))
            .toList());
      }
      Activity act = Activity.fromJson(
          json: activityJsons[i], person: person, participants: participants);
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
      LoggerService.log("Problem fetching likes", level: "w");
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
              List<Person> participants = [];
              if (data['participants'] != null &&
                  data['participants'] is List) {
                participants = await Future.wait(data['participants']
                    .map<Future<Person>>(
                        (p) async => await PersonService.getPerson(uid: p))
                    .toList());
              }
              return Activity.fromJson(
                  json: data, person: person, participants: participants);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Can't get activities.", level: "w");
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
      LoggerService.log("Can't fetch tags", level: "w");
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
