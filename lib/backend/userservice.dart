import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:letss_app/backend/cacheservice.dart';

import '../models/person.dart';
import '../backend/loggerservice.dart';

class UserService {
  static void updatePerson(Person person) {
    // converting before async call to be sure data can be changed afterwards
    Map<String, dynamic> jsondata = person.toJson();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(jsondata, SetOptions(merge: true));
  }

  static void markReviewRequeted() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"requestedReview": DateTime.now()});
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

  static Future<Person?> getPerson({String? uid}) async {
    if (uid == null) {
      if (FirebaseAuth.instance.currentUser == null) {
        return null;
      }
      uid = FirebaseAuth.instance.currentUser!.uid;
    }

    bool loaded = false;
    Map<String, dynamic>? data = await CacheService.loadJson(uid);
    if (data == null) {
      data =
          (await FirebaseFirestore.instance.collection('users').doc(uid).get())
              .data();
      loaded = true;
    }
    if (data != null) {
      late Person person;
      if (loaded) {
        person = Person.fromJson(uid: uid, json: data, datestring: false);
        // can't put data directly due to timestamp encoding
        CacheService.putJson(uid, person.toJson(datestring: true));
      } else {
        person = Person.fromJson(uid: uid, json: data, datestring: true);
      }
      return person;
    }
    return null;
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
            level: "w");
      }
    } catch (err) {
      LoggerService.log("Caught error: $err in activityservice", level: "e");
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> uploadImage(String name, File file) async {
    String imageRef = 'profilePics/' +
        FirebaseAuth.instance.currentUser!.uid +
        '/' +
        name +
        '.jpg';
    try {
      await FirebaseStorage.instance.ref(imageRef).putFile(file);
    } on FirebaseException catch (e) {
      LoggerService.log("Error in userservice with error: $e", level: "e");
    }
    String downloadURL =
        await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
    return downloadURL;
  }
}
