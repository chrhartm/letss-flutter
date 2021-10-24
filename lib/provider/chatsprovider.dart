import 'package:flutter/material.dart';

import '../backend/chatservice.dart';
import '../models/chat.dart';

class ChatsProvider extends ChangeNotifier {
  late Stream<Iterable<Chat>>? chatStream;

  ChatsProvider() {
    clearData();
  }

  void init() {
    if (chatStream == null) {
      chatStream = ChatService.streamChats();
    }
  }

  void clearData() {
    chatStream = null;
  }
}
