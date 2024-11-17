import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letss_app/backend/followerservice.dart';
import '../models/person.dart';
import '../models/follower.dart';

class FollowerProvider extends ChangeNotifier {
  late Stream<Iterable<Follower>>? followingStream;
  late Stream<Iterable<Follower>>? followerStream;

  FollowerProvider() {
    clearData();
    init();
  }

  void init() {
    initFollow();
  }

  void clearData() {
    followingStream = null;
    followerStream = null;
  }

  void initFollow() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    followingStream ??= FollowerService.streamFollowing();
    followerStream ??= FollowerService.streamFollowers();
  }

  Future<bool> isFollower(Person person) {
    if (followerStream == null) {
      return Future.value(false);
    }
    return followerStream!
        .any((follower) => follower.any((f) => f.person.uid == person.uid));
  }

  static Future<bool> amFollowing(Person person) {
    return FollowerService.amFollowing(followingUid: person.uid);
  }

  static Future<void> follow(
      {required Person person, required String trigger}) async {
    await FollowerService.follow(followingUid: person.uid, trigger: trigger);
  }

  static Future<void> unfollow({required Person person}) async {
    await FollowerService.unfollow(followingUid: person.uid);
  }
}
