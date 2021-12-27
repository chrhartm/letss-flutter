import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../backend/loggerservice.dart';

class UserService {
  static void markReviewRequeted() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"requestedReview": DateTime.now()});
  }

  static void markSupportRequested() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"lastSupportRequest": DateTime.now()});
  }

  static void updateLastOnline() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"lastOnline": DateTime.now()});
  }

  static Stream<Map<String, dynamic>?> streamUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);
  }

  static Future<void> delete() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-deleteUser');

    try {
      final results = await callable();
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log(
            "Tried to delete user, didn't get 200 but ${results.data}",
            level: "e");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in activityservice", level: "e");
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
