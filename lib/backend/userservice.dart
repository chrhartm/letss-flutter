import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/person.dart';

class UserService {
  static void setUser(Person person) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(person.toJson());
  }

  static Future<Person> getUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic>? data =
        (await FirebaseFirestore.instance.collection('users').doc(uid).get())
            .data();
    print(data);
    return Person.fromJson(uid, data!);
  }
}
