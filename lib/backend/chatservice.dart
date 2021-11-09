import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../backend/userservice.dart';
import '../models/message.dart';
import '../models/person.dart';
import '../models/chat.dart';
import '../backend/loggerservice.dart';
import 'notificationservice.dart';

class ChatService {
  static Stream<Iterable<Chat>> streamChats() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: uid)
        .orderBy('lastMessage.timestamp', descending: true)
        .snapshots()
        .asyncMap((QuerySnapshot list) =>
            Future.wait(list.docs.map((DocumentSnapshot snap) async {
              Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
              String otherUser = List.from(
                  Set.from(data['users']).difference(Set.from([uid])))[0];
              Person? person;
              if (data["status"] == "ARCHIVED") {
                person = Chat.archivePerson();
              } else {
                person = await UserService.getPerson(uid: otherUser);
              }
              return Chat.fromJson(json: data, person: person!, uid: snap.id);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Error in chatservice with error $e", level: "e");
    });
  }

  static void archiveChat(Chat chat) async {
    sendMessage(
            chat: chat,
            message: Message(
                message: "This chat was closed",
                timestamp: DateTime.now(),
                userId: FirebaseAuth.instance.currentUser!.uid))
        .then((val) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(chat.uid)
          .update({"status": "ARCHIVED"});
    });
  }

  static String generateChatId(
      {required String myUid, required String otherUid}) {
    return (otherUid.hashCode < myUid.hashCode)
        ? otherUid + '_' + myUid
        : myUid + '_' + otherUid;
  }

  static Future<Chat> startChat({required Person person}) async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = person.uid;
    String chatId = generateChatId(otherUid: otherUid, myUid: myUid);
    Chat chat = Chat(
        uid: chatId,
        status: 'ACTIVE',
        person: person,
        lastMessage:
            Message(message: "", timestamp: DateTime.now(), userId: myUid),
        read: [myUid]);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .set(chat.toJson());
    return chat;
  }

  static void updateChat(Chat chat) async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .update(chat.toJson());
  }

  static void markRead(Chat chat) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (!chat.read.contains(uid)) {
      chat.read.add(uid);
      updateChat(chat);
    }
  }

  // Below message stuff

  static Future sendMessage(
      {required Chat chat, required Message message}) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .collection("messages")
        .add(message.toJson());
    chat.lastMessage = message;
    chat.read = [chat.lastMessage.userId];
    updateChat(chat);
    NotificationsService.updateNotification(
        userId: chat.person.uid, newMessages: true);
    return;
  }

  static Stream<Iterable<Message>> streamMessages(Chat chat) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((QuerySnapshot list) => list.docs.map((DocumentSnapshot snap) =>
            Message.fromJson(json: snap.data() as Map<String, dynamic>)))
        .handleError((dynamic e) {
      LoggerService.log("Error in chatservice with error $e", level: "e");
    });
  }
}
