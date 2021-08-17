import 'package:flutter/material.dart';
import '../widgets/headerscreen.dart';
import '../widgets/messagebubble.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  List<Widget> _createMessages(List<Message> messages) {
    List<Widget> messageWidgets = [];

    messageWidgets.add(const SizedBox(height: 10));
    for (int i = 0; i < messages.length; i++) {
      messageWidgets.add(MessageBubble(
          message: chat.messages[i].message, me: chat.messages[i].me));
      messageWidgets.add(const SizedBox(height: 10));
    }
    messageWidgets.add(const SizedBox(height: 10));
    return messageWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: HeaderScreen(
        header: Row(children: [
          Image.memory(chat.person.pics[0],
              width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 10),
          Text(this.chat.person.name,
              style: Theme.of(context).textTheme.headline1)
        ]),
        child: Column(children: [
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ListView(
                      shrinkWrap: true,
                      children: _createMessages(this.chat.messages)))),
          TextFormField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Say something...'),
          )
        ]),
        back: true,
      )),
    );
  }
}
