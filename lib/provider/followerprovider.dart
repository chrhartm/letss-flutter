import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letss_app/backend/followerservice.dart';
import '../models/person.dart';
import '../models/follower.dart';

class FollowerProvider extends ChangeNotifier {
  late Stream<Iterable<Follower>>? followingStream;
  late Stream<Iterable<Follower>>? followerStream;

  Set<Follower> _followers = {};
  Set<Follower> _following = {};

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
    _followers.clear();
    _following.clear();
  }

  void initFollow() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    followingStream ??= FollowerService.streamFollowing();
    followerStream ??= FollowerService.streamFollowers();
    followingStream?.listen((followers) {
      _following = followers.toSet();
      notifyListeners();
    });

    followerStream?.listen((followers) {
      _followers = followers.toSet();
      notifyListeners();
    });
  }

  bool isFollower(Person person) {
    return _followers.any((f) => f.person.uid == person.uid);
  }

  bool amFollowing(Person person) {
    return _following.any((f) => f.person.uid == person.uid);
  }

  Future<void> follow({required Person person, required String trigger}) async {
    // Optimistic update
    _following.add(Follower(person: person, following: true, dateAdded: DateTime.now()));
    notifyListeners();

    try {
      await FollowerService.follow(followingUid: person.uid, trigger: trigger);
    } catch (e) {
      // Rollback on error
      _following.removeWhere((f) => f.person.uid == person.uid);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> unfollow({required Person person}) async {
    // Optimistic update
    Follower follower = _following.firstWhere((f) => f.person.uid == person.uid);
    _following.remove(follower);
    notifyListeners();

    try {
      await FollowerService.unfollow(followingUid: person.uid);
    } catch (e) {
      // Rollback on error
      _following.add(follower);
      notifyListeners();
      rethrow;
    }
  }

  List<Follower> get followers => _followers.toList();
  List<Follower> get following => _following.toList();
}
