import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../backend/chatservice.dart';

class ChatsProvider extends ChangeNotifier {
  List<Chat> chats = [];

  ChatsProvider() {
    loadChats();
  }

  void loadChats() async {
    this.chats.addAll(await ChatService.getChats());
    for (int i = 0; i < this.chats.length; i++) {
      chats[i].messages = await ChatService.getMessages(chats[i].uid);
    }
    notifyListeners();
  }
}
