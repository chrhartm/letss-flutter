import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatActivityData.dart';
import 'message.dart';
import "person.dart";

class Chat {
  String uid;
  List<Person> others;
  List<Person> personsLeft;
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
      required this.personsLeft,
      this.activityData});

  Chat.noChat()
      : others = [Person.emptyPerson(name: "Waiting for matches")],
        personsLeft = [],
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

  Map<String, dynamic> toJsonFull() {
    List<String> allUsers = [FirebaseAuth.instance.currentUser!.uid];
    allUsers.addAll(others.map((e) => e.uid));
    List<String> users = sortUsers(allUsers);
    return {
      'status': status,
      'lastMessage': lastMessage.toJson(),
      'users': users,
      'usersLeft': personsLeft.map((e) => e.uid).toList(),
      'read': read,
      'activityData': activityData == null ? null : activityData!.toJson(),
    };
  }

  Map<String, dynamic> toJsonMessageOnly() {
    return {
      'lastMessage': lastMessage.toJson(),
      'read': read,
    };
  }

  Chat.fromJson(
      {required Map<String, dynamic> json,
      required List<Person> others,
      required List<Person> personsLeft,
      Person? activityPerson})
      : others = others,
        personsLeft = personsLeft,
        lastMessage = Message.fromJson(json: json['lastMessage']),
        status = json['status'],
        uid = json['uid'],
        read = (json['read'] as List<dynamic>).map((x) => x as String).toList(),
        activityData = json['activityData'] == null
            ? null
            : ChatActivityData.fromJson(
                json: json['activityData'], person: activityPerson!);

  String get namePreview {
    if (activityData != null) {
      return activityData!.name;
    } else if (others.length > 0) {
      return others[0].name + others[0].supporterBadge;
    } else if (personsLeft.length > 0) {
      return personsLeft[0].name;
    } else {
      return "Unknown";
    }
  }

  Widget get thumbnail {
    if (activityData != null) {
      return activityData!.person.thumbnail;
    } else if (others.length > 0) {
      return others[0].thumbnail;
    } else if (personsLeft.length > 0) {
      return personsLeft[0].thumbnail;
    } else {
      return Person.emptyPerson().thumbnail;
    }
  }
}
