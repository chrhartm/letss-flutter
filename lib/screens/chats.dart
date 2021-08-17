import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';
import '../provider/chatsprovider.dart';
import '../widgets/textheaderscreen.dart';
import '../widgets/chatpreview.dart';

class Chats extends StatelessWidget {
  List<Widget> _createChats(List<Chat> chats) {
    List<Widget> widgets = [];

    for (int i = 0; i < chats.length; i++) {
      widgets.add(const SizedBox(height: 2));
      widgets.add(Divider(color: Colors.grey));
      widgets.add(const SizedBox(height: 2));
      widgets.add(ChatPreview(chat: chats[i]));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsProvider>(builder: (context, chats, child) {
      return TextHeaderScreen(
          header: "Chats",
          child: ListView(children: _createChats(chats.chats)));
    });
  }
}
