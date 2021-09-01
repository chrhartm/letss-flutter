import 'package:flutter/material.dart';
import '../widgets/headerscreen.dart';
import '../widgets/messagebubble.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    required this.chat,
    Key? key,
  }) : super(key: key);

  final Chat chat;

  @override
  ChatScreenState createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateMessage(String? value) {
    String val = value == null ? "" : value;
    if (val == "")
      return 'Please enter a valid message';
    else
      return null;
  }

  List<Widget> _createMessages(List<Message> messages) {
    List<Widget> messageWidgets = [];

    messageWidgets.add(const SizedBox(height: 10));
    for (int i = 0; i < messages.length; i++) {
      messageWidgets.add(MessageBubble(
          message: widget.chat.messages[i].message,
          me: widget.chat.messages[i].me));
      messageWidgets.add(const SizedBox(height: 10));
    }
    messageWidgets.add(const SizedBox(height: 10));
    return messageWidgets;
  }

  @override
  Widget build(BuildContext context) {
    // TODO use ChatConsumer here and access chat through index similar to activity
    return Scaffold(
      body: SafeArea(
          child: HeaderScreen(
        header: ListTile(
            leading: widget.chat.person.thumbnail,
            title: Text(widget.chat.person.name,
                style: Theme.of(context).textTheme.headline1)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: ListView(
                    shrinkWrap: true,
                    children: _createMessages(widget.chat.messages)),
              ),
              Form(
                  key: _formKey,
                  child: (Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: textController,
                          validator: validateMessage,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Say something...'),
                        )),
                        const SizedBox(width: 5),
                        RawMaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String message = textController.text;
                                print(message);
                              }
                            },
                            elevation: 2.0,
                            fillColor: Colors.white,
                            child: Icon(Icons.send_rounded,
                                size: 20.0, color: Colors.orange),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            constraints: BoxConstraints())
                      ]))),
            ]),
        back: true,
      )),
    );
  }
}
