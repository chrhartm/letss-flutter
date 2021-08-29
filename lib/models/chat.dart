import 'message.dart';
import "person.dart";

class Chat {
  String uid;
  Person person;
  List<Message> messages;
  String status;
  String lastMessage;

  Chat(
      {required this.uid,
      required this.status,
      required this.person,
      required this.messages,
      required this.lastMessage});
}
