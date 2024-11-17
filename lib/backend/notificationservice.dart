import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsService {
  static void updateNotification(
      {String? userId, bool? newMessages, bool? newLikes}) {
    Map<String, dynamic> payload = {};

    userId ??= FirebaseAuth.instance.currentUser!.uid;

    if (newMessages != null) {
      payload["newMessages"] = newMessages;
    }
    if (newLikes != null) {
      payload["newLikes"] = newLikes;
    }
    if (payload.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .set(payload, SetOptions(merge: true));
    }
  }
}
