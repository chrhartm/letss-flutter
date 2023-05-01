import 'package:firebase_auth/firebase_auth.dart';

import 'chatActivityData.dart';
import 'message.dart';
import "person.dart";

class Chat {
  String uid;
  List<Person> others;
  String status;
  Message lastMessage;
  List<String> read;
  ChatActivityData? activityData;

  Chat(
      {required this.uid,
      required this.status,
      required this.others,
      required this.lastMessage,
      required this.read,
      this.activityData});

  Chat.noChat()
      : others = [Person.emptyPerson(name: "Waiting for matches")],
        uid = "",
        status = 'ACTIVE',
        lastMessage = Message(
            message: "Chats will be shown here",
            // different userId than empty Person for read logic
            userId: "x",
            timestamp: DateTime.now()),
        read = [""];

  bool get isRead {
    return read.contains(FirebaseAuth.instance.currentUser!.uid);
  }

  static List<String> sortUsers(List<String> users) {
    users.sort((a, b) => a.hashCode.compareTo(b.hashCode));
    return users;
  }

  Map<String, dynamic> toJson() {
    List<String> allUsers = [FirebaseAuth.instance.currentUser!.uid];
    allUsers.addAll(others.map((e) => e.uid));
    List<String> users = sortUsers(allUsers);
    return {
      'status': status,
      'lastMessage': lastMessage.toJson(),
      'users': users,
      'read': read,
      'activityData': activityData == null ? null : activityData!.toJson(),
    };
  }

  Chat.fromJson(
      {required Map<String, dynamic> json,
      required List<Person> others,
      Person? activityPerson})
      : others = others,
        lastMessage = Message.fromJson(json: json['lastMessage']),
        status = json['status'],
        uid = json['uid'],
        read = (json['read'] as List<dynamic>).map((x) => x as String).toList(),
        activityData = json['activityData'] == null
            ? null
            : ChatActivityData.fromJson(
                json: json['activityData'], person: activityPerson!);
}
