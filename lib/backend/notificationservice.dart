import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsService {
  static void updateNotification(
      {String? userId, bool? newMessages, bool? newLikes}) {
    Map<String, dynamic> payload = {};
    if (userId == null) {
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    if (newMessages != null) {
      payload["newMessages"] = newMessages;
    }
    if (newLikes != null) {
      payload["newLikes"] = newLikes;
    }
    if (payload.length > 0) {
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(userId)
          .set(payload, SetOptions(merge: true));
    }
  }
}
