import 'package:flutter/material.dart';

import '../backend/chatservice.dart';
import '../models/chat.dart';
import '../models/person.dart';

class ChatsProvider extends ChangeNotifier {
  late Stream<Iterable<Chat>>? chatStream;

  ChatsProvider() {
    clearData();
  }

  void init() {
    chatStream ??= ChatService.streamChats();
  }

  void clearData() {
    chatStream = null;
  }

  static Future<Chat> getChatByPerson({required Person person}) async {
    return ChatService.getPersonChat(person: person);
  }
}
