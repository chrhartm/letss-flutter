import 'package:firebase_auth/firebase_auth.dart';

import 'message.dart';
import "person.dart";

class Chat {
  String uid;
  Person person;
  String status;
  Message lastMessage;
  Chat(
      {required this.uid,
      required this.status,
      required this.person,
      required this.lastMessage});

  Map<String, dynamic> toJson() => {
        'status': status,
        'lastMessage': lastMessage.toJson(),
        'users': (person.uid.hashCode <
                FirebaseAuth.instance.currentUser!.uid.hashCode)
            ? [person.uid, FirebaseAuth.instance.currentUser!.uid]
            : [FirebaseAuth.instance.currentUser!.uid, person.uid]
      };

  Chat.fromJson(
      {required Map<String, dynamic> json,
      required Person person,
      required String uid})
      : person = person,
        lastMessage = Message.fromJson(json: json['lastMessage']),
        status = json['status'],
        uid = uid;
}
