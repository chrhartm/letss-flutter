import 'package:flutter/material.dart';
import '../models/chat.dart';

class ChatsProvider extends ChangeNotifier {
  List<Chat> chats = [];

  ChatsProvider() {
    loadChats();
  }

  void loadChats() async {
    this.chats.add(await Chat.getDummy(1));
    this.chats.add(await Chat.getDummy(2));
    notifyListeners();
  }
}
