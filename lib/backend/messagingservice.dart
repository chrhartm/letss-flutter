import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../backend/loggerservice.dart';

class MessagingService {
  static void init() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('Got a message whilst in the foreground!');
      logger.d('Message data: ${message.data}');

      if (message.notification != null) {
        logger.d(
            'Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.instance.getToken().then((token) {
      if (token == null) {
        logger.w("no fcm token");
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

    logger.d("Handling a background message: ${message.messageId}");
  }

  static void updateToken(String token) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    logger.d("Updating FCM token: $token");
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      "token": {"token": token, "timestamp": DateTime.now()}
    });
  }
}
