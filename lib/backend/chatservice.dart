import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/models/chatActivityData.dart';

import '../models/activity.dart';
import '../models/message.dart';
import '../models/person.dart';
import '../models/chat.dart';
import '../backend/loggerservice.dart';
import 'notificationservice.dart';

class ChatService {
  static Future<Chat> _mapChatData(
      Map<String, dynamic> data, String uid) async {
    data['uid'] = uid;
    List<String> otherUsers = List.from(Set.from(data['users'])
        .difference(Set.from([FirebaseAuth.instance.currentUser!.uid])));
    List<Person> others = await Future.wait(otherUsers
        .map((String otherUser) => PersonService.getPerson(uid: otherUser)));
    // TODO remove archive logic
    if (data["status"] == "ARCHIVED") {
      others[0].name = 'Closed - ' + others[0].name;
    }
    Person? activityPerson = null;
    if (data['activityData'] != null) {
      activityPerson =
          await PersonService.getPerson(uid: data['activityData']['user']);
    }
    return Chat.fromJson(
        json: data, others: others, activityPerson: activityPerson);
  }

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
              return _mapChatData(data, snap.id);
            })))
        .handleError((dynamic e) {
      LoggerService.log("Failed to load chats\n$e", level: "e");
    });
  }

  static Future<Chat> getPersonChat({required Person person}) async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = person.uid;
    String chatId = generatePersonChatId(otherUid: otherUid, myUid: myUid);
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    if (doc.exists) {
      return _mapChatData(doc.data() as Map<String, dynamic>, chatId);
    } else {
      return startPersonChat(person: person);
    }
  }

  static Future<Chat> joinActivityChat(
      {required Person person, required Activity activity}) async {
    DateTime now = DateTime.now();
    String chatId = generateActivityChatId(activityId: activity.uid);
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    if (doc.exists) {
      return _mapChatData(doc.data() as Map<String, dynamic>, chatId);
    } else {
      Chat chat = await startActivityChat(activity: activity);
      ChatService.sendMessage(
          chat: chat,
          message: Message(
              message: activity.name,
              userId: FirebaseAuth.instance.currentUser!.uid,
              timestamp: now));
      if (activity.hasDescription) {
        ChatService.sendMessage(
            chat: chat,
            message: Message(
                message: activity.description!,
                userId: FirebaseAuth.instance.currentUser!.uid,
                timestamp: now.add(const Duration(seconds: 1))));
      }
      return chat;
    }
  }

  static void leaveChat(Chat chat) async {
    await sendMessage(
            chat: chat,
            message: Message(
                message: "-- Left this chat --",
                timestamp: DateTime.now(),
                userId: FirebaseAuth.instance.currentUser!.uid))
        .then((val) {
      FirebaseFirestore.instance.collection('chats').doc(chat.uid).update(
          {"users": Chat.sortUsers(chat.others.map((e) => e.uid).toList())});
    });
  }

  static String generatePersonChatId(
      {required String myUid, required String otherUid}) {
    return (otherUid.hashCode < myUid.hashCode)
        ? otherUid + '_' + myUid
        : myUid + '_' + otherUid;
  }

  static String generateActivityChatId({required String activityId}) {
    return 'activity_' + activityId;
  }

  static Future<Chat> startPersonChat({required Person person}) async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    String otherUid = person.uid;
    String chatId = generatePersonChatId(otherUid: otherUid, myUid: myUid);
    Chat chat = Chat(
        uid: chatId,
        status: 'ACTIVE',
        others: [person],
        lastMessage:
            Message(message: "", timestamp: DateTime.now(), userId: myUid),
        read: [myUid]);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .set(chat.toJson());
    return chat;
  }

  static Future<Chat> startActivityChat({required Activity activity}) async {
    String chatId = generateActivityChatId(activityId: activity.uid);
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    Chat chat = Chat(
        uid: chatId,
        status: 'ACTIVE',
        others: activity.participants.map((p) => p.person).toList(),
        lastMessage: Message(
          message: "",
          timestamp: DateTime.now(),
          userId: myUid,
        ),
        read: [myUid],
        activityData: ChatActivityData.fromActivity(activity));
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
    FirebaseFirestore.instance.collection('chats').doc(chat.uid).update({
      "read": FieldValue.arrayUnion([uid])
    });
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
    chat.others.forEach((person) {
      if (person.uid != message.userId) {
        NotificationsService.updateNotification(
            userId: person.uid, newMessages: true);
      }
    });
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
      LoggerService.log("Failed to load messages\n$e", level: "e");
    });
  }
}
