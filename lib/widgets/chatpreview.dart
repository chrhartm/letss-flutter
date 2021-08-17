import 'package:flutter/material.dart';
import '../screens/chatscreen.dart';
import '../models/chat.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(chat: this.chat)));
        },
        child: Row(children: [
          Image.memory(chat.person.pics[0],
              width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 5),
          Expanded(
              child: Column(children: [
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                    chat.person.name + ", " + chat.person.age.toString(),
                    style: Theme.of(context).textTheme.headline5)),
            Align(
                alignment: Alignment.topLeft,
                child: Text(chat.messages.last.message,
                    style: Theme.of(context).textTheme.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis))
          ]))
        ]));
  }
}
