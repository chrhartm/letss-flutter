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
        .orderBy('timestamp')
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
      chats.add(Chat(
          messages: [],
          person: person,
          lastMessage: chatJsons[i]['lastMessage'],
          uid: chatIds[i],
          status: chatJsons[i]['status']));
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
        messages.add(Message(
            message: data['message'],
            dateSent: data['timestamp'].toDate(),
            me: data['user'] == uid));
      });
    });

    return messages;
  }
}
