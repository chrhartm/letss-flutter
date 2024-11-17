import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/models/follower.dart';
import '../backend/loggerservice.dart';
import '../models/person.dart';

class FollowerService {
  static Stream<Iterable<Follower>> streamFollowers() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('followers')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot list) =>
            Future.wait(list.docs.map((DocumentSnapshot snap) async {
              Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
              Person person = await PersonService.getPerson(uid: snap.id);
              return Follower.fromJson(
                  json: data, person: person, following: false);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Couldn't to load followers.", level: "w");
    });
  }

  static Stream<Iterable<Follower>> streamFollowing() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('following')
        .orderBy('dateAdded', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot list) =>
            Future.wait(list.docs.map((DocumentSnapshot snap) async {
              Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
              Person person = await PersonService.getPerson(uid: snap.id);
              return Follower.fromJson(
                  json: data, person: person, following: true);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Couldn't to load people you follow", level: "w");
    });
  }

  static Future<void> follow(
      {required String followingUid, required String trigger}) async {
    String followerUid = FirebaseAuth.instance.currentUser!.uid;
    if (!Follower.triggerValues.contains(trigger)) {
      trigger = "UNKNOWN";
      LoggerService.log("unknown trigger: $trigger", level: "w");
    }
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(followerUid)
        .collection('following')
        .doc(followingUid)
        .set(Follower.jsonFromRawData(
            dateAdded: DateTime.now(), trigger: trigger));
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(followingUid)
        .collection('followers')
        .doc(followerUid)
        .set(Follower.jsonFromRawData(
            dateAdded: DateTime.now(), trigger: trigger));
  }

  static Future<void> unfollow({required String followingUid}) async {
    String followerUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(followerUid)
        .collection('following')
        .doc(followingUid)
        .delete();
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(followingUid)
        .collection('followers')
        .doc(followerUid)
        .delete();
  }

  static Future<bool> amFollowing({required String followingUid}) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = followingUid;
    return FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('following')
        .doc(otherUid)
        .get()
        .then((DocumentSnapshot snap) => snap.exists);
  }
}
