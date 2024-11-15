import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:letss_app/backend/userservice.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../backend/loggerservice.dart';

class MessagingService {
  static final MessagingService _me = MessagingService._internal();
  MessagingService._internal();

  factory MessagingService() {
    return _me;
  }

  static Future<bool> openNotificationSettings() {
    return openAppSettings();
  }

  static Future<bool> notificationsEnabled() {
    return FirebaseMessaging.instance
        .getNotificationSettings()
        .then((settings) {
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    });
  }

  static Future<bool> notificationsDenied() {
    return FirebaseMessaging.instance
        .getNotificationSettings()
        .then((settings) {
      return settings.authorizationStatus == AuthorizationStatus.denied;
    });
  }

  static Future<void> requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
            sound: true,
            badge: true,
            alert: true,
            provisional: false,
            carPlay: false,
            criticalAlert: false,
            announcement: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      LoggerService.log('User granted provisional permission');
    } else {
      // Navigate to systems setting
      openNotificationSettings();
      LoggerService.log('User declined or has not accepted permission');
    }
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    LoggerService.log("Message received: " + message.toString());
    if (message.data.containsKey("link")) {
      String rawLink = message.data["link"];
      // Generate URI from rawlink
      Uri link = Uri.parse(rawLink);
      LinkService.instance.processLink(context, link);
    }
  }

  void init(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LoggerService.log('Got a message whilst in the foreground!');
      LoggerService.log('Message data: ${message.data}');

      if (message.notification != null) {
        LoggerService.log(
            'Message also contained a notification: ${message.notification!.title!}');
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleMessage(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(context, message);
    });

    FirebaseMessaging.instance.getToken().then((token) {
      if (token == null) {
        LoggerService.log("no fcm token", level: "w");
      } else {
        updateToken(token);
      }
    }).onError((error, stackTrace) =>
        LoggerService.log("Error getting token " + error.toString()));

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateToken(newToken);
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    // if platform is iOS, then increase badge count
    if (!kIsWeb && Platform.isIOS) {
      FlutterAppBadger.updateBadgeCount(1);
    }
    LoggerService.log("Handling a background message: ${message.messageId}");
  }

  void updateToken(String token) {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    UserService.updateToken(token);
  }
}
