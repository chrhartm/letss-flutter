import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';

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
  Activity? activity;

  Chat(
      {required this.uid,
      required this.status,
      required this.others,
      required this.lastMessage,
      required this.read,
      required this.personsLeft,
      this.activityData});

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
      'activityData': activityData?.toJson(),
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
      required this.others,
      required this.personsLeft,
      Person? activityPerson,
      this.activity})
      : 
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
    } else if (others.isNotEmpty) {
      return others[0].name + others[0].supporterBadge;
    } else if (personsLeft.isNotEmpty) {
      return personsLeft[0].name;
    } else {
      return "Unknown";
    }
  }

  Widget get thumbnail {
    if (activityData != null) {
      if (activity != null) {
        return activity!.thumbnail;
      } else {
        return activityData!.person.thumbnail;
      }
    } else if (others.isNotEmpty) {
      return others[0].thumbnail;
    } else if (personsLeft.isNotEmpty) {
      return personsLeft[0].thumbnail;
    } else {
      return Person.emptyPerson().thumbnail;
    }
  }
}
