import 'package:firebase_auth/firebase_auth.dart';

import 'message.dart';
import "person.dart";

class Chat {
  String uid;
  Person person;
  String status;
  Message lastMessage;
  List<String> read;
  Chat(
      {required this.uid,
      required this.status,
      required this.person,
      required this.lastMessage,
      required this.read});

  Chat.noChat()
      : person = Person.emptyPerson(name: "Waiting for matches"),
        uid = "",
        status = 'ACTIVE',
        lastMessage = Message(
            message: "Chats will be shown here",
            // different userId than empty Person for read logic
            userId: "x",
            timestamp: DateTime.now()),
        read = [""];

  Map<String, dynamic> toJson() => {
        'status': status,
        'lastMessage': lastMessage.toJson(),
        'users': (person.uid.hashCode <
                FirebaseAuth.instance.currentUser!.uid.hashCode)
            ? [person.uid, FirebaseAuth.instance.currentUser!.uid]
            : [FirebaseAuth.instance.currentUser!.uid, person.uid],
        'read': read
      };

  Chat.fromJson(
      {required Map<String, dynamic> json,
      required Person person,
      required String uid})
      : person = person,
        lastMessage = Message.fromJson(json: json['lastMessage']),
        status = json['status'],
        uid = uid,
        read = (json['read'] as List<dynamic>).map((x) => x as String).toList();

  static Person archivePerson() {
    return Person(
        bio: "This chat was closed",
        name: "Closed",
        gender: "",
        dob: DateTime.now(),
        job: "",
        interests: [],
        uid: "CLOSED",
        badge: "");
  }
}
