import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../backend/chatservice.dart';
import '../widgets/textheaderscreen.dart';
import '../widgets/chatpreview.dart';

class Chats extends StatelessWidget {
  Widget _buildChat(Chat chat, bool clickable) {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 2));
    widgets.add(Divider());
    widgets.add(const SizedBox(height: 2));
    widgets.add(ChatPreview(chat: chat, clickable: clickable));

    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextHeaderScreen(
      header: "Chats",
      child: StreamBuilder(
          stream: ChatService.streamChats(),
          builder: (BuildContext context, AsyncSnapshot<Iterable<Chat>> chats) {
            if (chats.hasData && chats.data!.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) =>
                    _buildChat(chats.data!.elementAt(index), true),
                itemCount: chats.data!.length,
                reverse: false,
              );
            } else {
              return _buildChat(Chat.noChat(), false);
            }
          }),
    ));
  }
}
