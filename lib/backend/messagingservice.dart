import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../backend/loggerservice.dart';

class MessagingService {
  static final MessagingService _me = MessagingService._internal();

  MessagingService._internal();

  factory MessagingService() {
    return _me;
  }

  static void requestPermissions() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
      LoggerService.log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      LoggerService.log('User granted provisional permission');
    } else {
      LoggerService.log('User declined or has not accepted permission');
    }
  }

  void init() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LoggerService.log('Got a message whilst in the foreground!');
      LoggerService.log('Message data: ${message.data}');

      if (message.notification != null) {
        LoggerService.log(
            'Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.instance.getToken().then((token) {
      if (token == null) {
        LoggerService.log("no fcm token", level: "w");
      } else {
        updateToken(token);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateToken(newToken);
    });
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    LoggerService.log("Handling a background message: ${message.messageId}");
  }

  void updateToken(String token) {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    var uid = FirebaseAuth.instance.currentUser!.uid;
    LoggerService.log("Updating FCM token: $token");
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      "token": {"token": token, "timestamp": DateTime.now()}
    });
  }
}
