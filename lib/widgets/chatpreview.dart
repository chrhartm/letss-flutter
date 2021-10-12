import 'package:flutter/material.dart';
import '../screens/chatscreen.dart';
import '../models/chat.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key, required this.chat, this.clickable = true})
      : super(key: key);

  final Chat chat;
  final bool clickable;

  @override
  Widget build(BuildContext context) {
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
      title: Text(chat.person.name + ", " + chat.person.age.toString(),
          style: Theme.of(context).textTheme.headline5),
      subtitle: Text(chat.lastMessage.message,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
