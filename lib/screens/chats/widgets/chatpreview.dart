import 'package:flutter/material.dart';

import '../chatscreen.dart';
import '../../../models/chat.dart';

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
        // First part for when a user was deleted and never more > 1 read
        ((chat.read.length == 1 && !chat.read.contains(chat.person.uid)) ||
            (chat.read.length > 1) ||
            chat.lastMessage.userId != chat.person.uid);
    Widget name = Text(chat.person.name + chat.person.supporterBadge,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(fontWeight: FontWeight.bold));

    return ListTile(
      onTap: () {
        if (this.clickable) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: '/chats/chat'),
                  builder: (context) => ChatScreen(chat: this.chat)));
        }
      },
      leading: chat.person.thumbnail,
      title: name,
      subtitle: Text(chat.lastMessage.message,
          style: (read || !clickable) ? readstyle : unreadstyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
