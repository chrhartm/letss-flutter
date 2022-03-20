import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:letss_app/models/subscription.dart';

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
      LoggerService.log("Caught error: $err in userservice", level: "w");
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
      LoggerService.log("Caught error: $err in userservice", level: "w");
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
      LoggerService.log("Caught error: $err in userservice", level: "w");
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
      LoggerService.log("Caught error: $err in userservice", level: "w");
    }
  }

  static Stream<Map<String, dynamic>?> streamUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>);
  }

  static Future<Subscription> getSubscriptionDetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data["subscription"] != null) {
        return Subscription.fromJson(json: data["subscription"]);
      } else {
        return Subscription.emptySubscription();
      }
    });
  }

  static Future<bool> updateSubscription(Subscription subscription) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-updateSubscription');
    try {
      final results = await callable.call(subscription.toJson());
      if (results.data["code"] == 200) {
        return true;
      } else {
        LoggerService.log("Failed to update subscription: ${results.data}",
            level: "e");
        return false;
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "e");
      return false;
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
        LoggerService.log("Failed to delete user\n${results.data}", level: "e");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "w");
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
