import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letss_app/backend/userservice.dart';
import 'package:letss_app/models/message.dart';
import 'package:letss_app/models/person.dart';
import '../models/chat.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    List<Chat> chats = [];
    List<Map<String, dynamic>> chatJsons = [];
    List<String> chatIds = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: uid)
        .where('status', isEqualTo: 'ACTIVE')
        .orderBy('lastMessage.timestamp')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        chatJsons.add(doc.data() as Map<String, dynamic>);
        chatIds.add(doc.id);
      });
    });

    for (int i = 0; i < chatJsons.length; i++) {
      String otherUser = List.from(
          Set.from(chatJsons[i]['users']).difference(Set.from([uid])))[0];
      Person person = await UserService.getUser(uid: otherUser);
      chats.add(
          Chat.fromJson(json: chatJsons[i], person: person, uid: chatIds[i]));
    }

    return chats;
  }

  static Future<List<Message>> getMessages(String chatId) async {
    List<Message> messages = [];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        messages.add(Message.fromJson(json: data));
      });
    });

    return messages;
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
        messages: [],
        lastMessage:
            Message(message: "", timestamp: DateTime.now(), userId: myUid));
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .set(chat.toJson());
    return chat;
  }

  static void sendMessage(
      {required Chat chat, required Message message}) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .collection("messages")
        .add(message.toJson());
    chat.lastMessage = message;
    updateChat(chat);
  }

  static void updateChat(Chat chat) async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.uid)
        .update(chat.toJson());
  }
}
