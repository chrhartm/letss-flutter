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
              Person person = await PersonService.getPerson(uid: data['user']);
              return Follower.fromJson(
                  json: data, person: person, following: false);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Failed to load followers\n$e", level: "e");
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
              Person person = await PersonService.getPerson(uid: data['user']);
              return Follower.fromJson(
                  json: data, person: person, following: true);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Failed to load following\n$e", level: "e");
    });
  }

  static Future<void> follow({required Person person}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = person.uid;
    // TODO add write permissions
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('following')
        .doc(otherUid)
        .set(
            Follower(dateAdded: DateTime.now(), person: person, following: true)
                .toJson());
    // TODO could be refactored as cloud function for extra security
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(otherUid)
        .collection('followers')
        .doc(uid)
        .set(Follower(
                dateAdded: DateTime.now(), person: person, following: false)
            .toJson());
  }

  static Future<void> unfollow({required Person person}) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = person.uid;
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('following')
        .doc(otherUid)
        .delete();
    await FirebaseFirestore.instance
        .collection('followers')
        .doc(otherUid)
        .collection('followers')
        .doc(uid)
        .delete();
  }

  static Future<bool> amFollowing({required Person person}) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = person.uid;
    return FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('following')
        .doc(otherUid)
        .get()
        .then((DocumentSnapshot snap) => snap.exists);
  }
}
