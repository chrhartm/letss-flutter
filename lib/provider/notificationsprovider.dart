import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../backend/notificationservice.dart';
import '../provider/userprovider.dart';

class NotificationsProvider extends ChangeNotifier {
  late String _activeTab;
  late bool newMessages;
  late bool newLikes;
  late UserProvider _user;

  NotificationsProvider(UserProvider user) {
    this._user = user;
    clearData();
    if (user.initialized) {
      initNotifications();
    }
  }

  void init() {
    initNotifications();
  }

  void clearData() {
    newMessages = false;
    newLikes = false;
    _activeTab = "/activities";
  }

  void set activeTab(String activeTab) {
    _activeTab = activeTab;
    if (activeTab == "/chats" && newMessages == true) {
      newMessages = false;
      NotificationsService.updateNotification(newMessages: false);
    }
    if (activeTab == "/myactivities" && newLikes == true) {
      newLikes = false;
      NotificationsService.updateNotification(newLikes: false);
    }
  }

  void initNotifications() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("notifications")
        .doc(uid)
        .snapshots()
        .listen((event) {
      if (event.data() != null) {
        if ((event.data()!['newMessages'] == true)) {
          if (_activeTab == "/chats") {
            NotificationsService.updateNotification(newMessages: false);
          } else {
            newMessages = true;
            notifyListeners();
          }
        }
        if ((event.data()!['newLikes'] == true)) {
          if (_activeTab == "/myactivities") {
            NotificationsService.updateNotification(newLikes: false);
          } else {
            newLikes = true;
            notifyListeners();
          }
        }
      }
    });
  }
}
