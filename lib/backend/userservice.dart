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
      await callable();
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log(e.message!, level: "e");
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "w");
    }
  }

  static void markSupportRequested() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-markSupportRequested');
    try {
      await callable();
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log(e.message!, level: "e");
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "w");
    }
  }

  static void updateLastOnline() async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-updateLastOnline');
    try {
      await callable();
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log(e.message!, level: "e");
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "w");
    }
  }

  static void updateToken(String token) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-updateToken');
    try {
      await callable.call({"token": token});
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log(e.message!, level: "e");
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
      await callable.call(subscription.toJson());
      return true;
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log("Failed to update subscription: ${e.message}",
          level: "e");
      return false;
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
      await callable();
    } on FirebaseFunctionsException catch (_) {
      LoggerService.log("Failed to delete user.", level: "i");
    } catch (err) {
      LoggerService.log("Caught error: $err in userservice", level: "w");
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
