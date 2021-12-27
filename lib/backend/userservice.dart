import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../backend/loggerservice.dart';

class UserService {
  static void markReviewRequeted() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-markReviewRequested');
    try {
      final results = await callable();
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log(
            "Tried to update user support requested, didn't get 200 but ${results.data}");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "e");
    }
  }

  static void markSupportRequested() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-markSupportRequested');
    try {
      final results = await callable();
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log(
            "Tried to update user support requested, didn't get 200 but ${results.data}");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "e");
    }
  }

  static void updateLastOnline() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-updateLastOnline');
    try {
      final results = await callable();
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log(
            "Tried to update user last online, didn't get 200 but ${results.data}");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "e");
    }
  }

  static void updateToken(String token) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-updateToken');
    try {
      final results = await callable.call({"token": token});
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log(
            "Tried to update user token, didn't get 200 but ${results.data}");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "e");
    }
  }

  static Stream<Map<String, dynamic>?> streamUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);
  }

  static Future subscribe(String badge) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-subscribe');
    try {
      final results = await callable.call({"badge": badge});
      if (results.data["code"] == 200) {
        return;
      } else {
        LoggerService.log(
            "Tried to subscribe user, didn't get 200 but ${results.data}",
            level: "e");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "e");
    }
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
      LoggerService.log("Caught error: $err in userservice", level: "e");
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
