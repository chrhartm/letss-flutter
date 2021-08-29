import 'package:flutter/material.dart';
import '../screens/chatscreen.dart';
import '../models/chat.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(chat: this.chat)));
      },
      leading: chat.person.thumbnail,
      title: Text(chat.person.name + ", " + chat.person.age.toString(),
          style: Theme.of(context).textTheme.headline5),
      subtitle: Text(chat.lastMessage,
          style: Theme.of(context).textTheme.body2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
