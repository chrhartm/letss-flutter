import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/models/like.dart';
import 'package:letss_app/models/locationinfo.dart';
import 'package:letss_app/models/template.dart';

import 'activitypersondata.dart';
import 'person.dart';
import 'category.dart';

class Activity {
  String uid;
  String name;
  String? description;
  String status;
  List<Category>? categories;
  List<Person> participants;
  Person person;
  DateTime timestamp;
  LocationInfo? location;
  ActivityPersonData? personData;
  List<Like>? likes;
  StreamSubscription? _likesSubscription;

  void initializeLikesStream() {
    if (person.isMe) {
      _likesSubscription?.cancel();
      _likesSubscription =
          ActivityService.streamMyLikes(uid).listen((updatedLikes) {
        likes = updatedLikes.toList();
      });
    }
  }

  void dispose() {
    _likesSubscription?.cancel();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categories':
            hasCategories ? categories!.map((e) => e.name).toList() : [],
        'user': person.uid,
        'status': status,
        'timestamp': timestamp,
        'location': location?.toJson(),
        'personData': person.activityPersonData.toJson(),
        'participants': participants.map((e) => e.uid).toList(),
      };
  Activity.fromJson(
      {required Map<String, dynamic> json,
      required this.person,
      required this.participants,
      this.likes})
      : uid = json['uid'],
        name = json['name'],
        description = json['description'],
        categories = json["categories"] == null
            ? []
            : List.from(json['categories'])
                .map((e) => Category.fromString(name: e))
                .toList(),
        status = json['status'],
        location = json['location'] == null
            ? null
            : LocationInfo.fromJson(json['location']),
        personData = json['personData'] == null
            ? null
            : ActivityPersonData.fromJson(json: json['personData']),
        timestamp = json['timestamp'].toDate() {
    initializeLikesStream();
  }

  Activity.fromTemplate({required Template template, required this.person})
      : uid = "",
        name = template.name,
        description = template.description,
        // Don't include categories from template
        // to avoid having to deal with category updates
        // for notifications for now
        categories = [], // template.categories,
        status = "ACTIVE",
        location = person.location,
        personData = person.activityPersonData,
        timestamp = DateTime.now(),
        participants = [] {
    initializeLikesStream();
  }

  bool isComplete() {
    if (name == "" ||
        status == "" ||
        categories == null ||
        categories!.isEmpty) {
      return false;
    }
    return true;
  }

  String matchId({required String userId}) {
    return "${uid}_$userId";
  }

  String get locationString {
    if (location == null) {
      return "";
    }
    return location!.generateLocation();
  }

  bool get hasDescription {
    if (description == null || description == "") {
      return false;
    } else {
      return true;
    }
  }

  bool get hasCategories {
    if (categories == null || categories!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool get hasParticipants {
    if (participants.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool get isArchived {
    if (status == "ARCHIVED") {
      return true;
    } else {
      return false;
    }
  }

  bool hasParticipant(Person person) {
    if (participants.any((p) => p.uid == person.uid)) {
      return true;
    } else {
      return false;
    }
  }

  Widget get thumbnail {
    return participants.isNotEmpty
        ? person.thumbnailWithCounter(participants.length)
        : person.thumbnail;
  }

  bool get isMine {
    return person.isMe;
  }

  bool get joining {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return participants.any((element) => element.uid == uid) || isMine;
  }

  int get likeCount {
    return likes?.length ?? 0;
  }

  Activity(
      {required this.uid,
      required this.name,
      required this.description,
      required this.categories,
      required this.person,
      required this.status,
      required this.timestamp,
      required this.participants});

  Activity.emptyActivity(this.person)
      : uid = "",
        name = "",
        status = "ACTIVE",
        timestamp = DateTime.now(),
        participants = [];
}
