import 'package:flutter/material.dart';

import '../screens/chatscreen.dart';
import '../models/chat.dart';
import '../backend/chatservice.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key, required this.chat, this.clickable = true})
      : super(key: key);

  final Chat chat;
  final bool clickable;

  @override
  Widget build(BuildContext context) {
    TextStyle readstyle = Theme.of(context).textTheme.bodyText2!;
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);
    bool read =
        (chat.read.length > 1 || chat.lastMessage.userId != chat.person.uid);
    return ListTile(
      onTap: () {
        if (this.clickable) {
          ChatService.markRead(chat);
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: '/chats/chat'),
                  builder: (context) => ChatScreen(chat: this.chat)));
        }
      },
      leading: chat.person.thumbnail,
      title: Text(chat.person.name + ", " + chat.person.age.toString(),
          style: Theme.of(context).textTheme.headline5),
      subtitle: Text(chat.lastMessage.message,
          style: read ? readstyle : unreadstyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
