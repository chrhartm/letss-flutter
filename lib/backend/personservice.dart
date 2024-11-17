import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:letss_app/backend/cacheservice.dart';

import '../models/person.dart';
import '../backend/loggerservice.dart';

class PersonService {
  static Future updatePerson(Person person) async {
    // converting before async call to be sure data can be changed afterwards
    Map<String, dynamic> jsondata = person.toJson();
    await FirebaseFirestore.instance
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
        .map((DocumentSnapshot doc) {
      Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
      json['uid'] = doc.id;
      return Person.fromJson(json: json);
    });
  }

  static Future<Person> getPerson({String? uid}) async {
    Person nullPerson = Person.emptyPerson(uid: uid ?? "");
    if (uid == null) {
      if (FirebaseAuth.instance.currentUser == null) {
        return nullPerson;
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
      data['uid'] = uid;
      late Person person;
      if (loaded) {
        person = Person.fromJson(json: data);
        CacheService.putJson(uid, data);
      } else {
        person = Person.fromJson(json: data);
      }
      return person;
    }
    return nullPerson;
  }

  static Future<String> uploadImage(String name, File file) async {
    String imageRef = 'profilePics/${FirebaseAuth.instance.currentUser!.uid}/$name.jpg';
    try {
      await FirebaseStorage.instance.ref(imageRef).putFile(file);
    } on FirebaseException catch (_) {
      LoggerService.log("Couldn't upload image. Please try again.", level: "w");
    }
    String downloadURL =
        await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
    return downloadURL;
  }
}
