import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../widgets/tiles/textheaderscreen.dart';
import 'widgets/chatpreview.dart';
import '../../provider/chatsprovider.dart';

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
    return Consumer<ChatsProvider>(builder: (context, chats, child) {
      return Scaffold(
          body: TextHeaderScreen(
        header: "Chats",
        child: StreamBuilder(
            stream: chats.chatStream,
            builder:
                (BuildContext context, AsyncSnapshot<Iterable<Chat>> chats) {
              if (chats.hasData && chats.data!.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) =>
                      _buildChat(chats.data!.elementAt(index), true),
                  itemCount: chats.data!.length,
                  reverse: false,
                );
              } else if (chats.connectionState == ConnectionState.waiting) {
                return Scaffold();
              } else {
                return _buildChat(Chat.noChat(), false);
              }
            }),
      ));
    });
  }
}
