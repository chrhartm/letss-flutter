import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:letss_app/backend/cacheservice.dart';

import '../models/person.dart';
import '../backend/loggerservice.dart';

class PersonService {
  static void updatePerson(Person person) {
    // converting before async call to be sure data can be changed afterwards
    Map<String, dynamic> jsondata = person.toJson();
    FirebaseFirestore.instance
        .collection('persons')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(jsondata, SetOptions(merge: true));
  }

  static Stream<Person?> streamPerson() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('persons')
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot doc) => Person.fromJson(
            uid: uid, json: doc.data() as Map<String, dynamic>));
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
      data = (await FirebaseFirestore.instance
              .collection('persons')
              .doc(uid)
              .get())
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
