import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../models/person.dart';

class UserService {
  static void setUser(Person person) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(person.toJson());
  }

  static Future<Person> getUser({String? uid}) async {
    if (uid == null) {
      uid = FirebaseAuth.instance.currentUser!.uid;
    }
    Map<String, dynamic>? data =
        (await FirebaseFirestore.instance.collection('users').doc(uid).get())
            .data();
    return Person.fromJson(uid: uid, json: data!);
  }

  static Future<String> uploadImage(File file) async {
    String imageRef =
        'profilePics/' + FirebaseAuth.instance.currentUser!.uid + '.jpg';
    try {
      await FirebaseStorage.instance.ref(imageRef).putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
    String downloadURL =
        await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
    return downloadURL;
  }

  static Map<String, dynamic> generateGeoHash(
      {required double latitude, required double longitude}) {
    final geo = Geoflutterfire();
    GeoFirePoint myLocation =
        geo.point(latitude: latitude, longitude: longitude);
    return myLocation.data;
  }
}
