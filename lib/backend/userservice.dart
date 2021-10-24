import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/person.dart';
import '../backend/loggerservice.dart';

class UserService {
  static void updatePerson(Person person) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(person.toJson(), SetOptions(merge: true));
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
    Map<String, dynamic>? data =
        (await FirebaseFirestore.instance.collection('users').doc(uid).get())
            .data();
    if (data != null) {
      return Person.fromJson(uid: uid, json: data);
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
        logger.w("Tried to delete user, didn't get 200 but ${results.data}");
      }
    } catch (err) {
      logger.e("Caught error: $err in activityservice");
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<String> uploadImage(File file) async {
    String imageRef =
        'profilePics/' + FirebaseAuth.instance.currentUser!.uid + '.jpg';
    try {
      await FirebaseStorage.instance.ref(imageRef).putFile(file);
    } on FirebaseException catch (e) {
      logger.e("Error in userservice with error: $e");
    }
    String downloadURL =
        await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
    return downloadURL;
  }
}
