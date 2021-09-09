import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../backend/chatservice.dart';

class ChatsProvider extends ChangeNotifier {
  List<Chat> chats = [];

  ChatsProvider() {
    loadChats();
  }

  void loadChats() async {
    this.chats = await ChatService.getChats();
    notifyListeners();
  }
}
