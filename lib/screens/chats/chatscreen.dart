import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/chats/profile.dart';
import 'package:letss_app/screens/chats/widgets/archiveDialog.dart';
import '../../backend/chatservice.dart';
import '../widgets/screens/headerscreen.dart';
import '../widgets/other/messagebubble.dart';
import '../../models/chat.dart';
import '../../models/message.dart';

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

  Widget _buildMessage(Message message) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: MessageBubble(
            message: message.message,
            me: message.userId == FirebaseAuth.instance.currentUser!.uid));
  }

  void block() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: HeaderScreen(
        header: ListTile(
            leading: GestureDetector(
                child: widget.chat.person.thumbnail,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings:
                              const RouteSettings(name: '/chats/chat/profile'),
                          builder: (context) =>
                              Profile(person: widget.chat.person)));
                }),
            title: Text(widget.chat.person.name,
                style: Theme.of(context).textTheme.headline1),
            trailing: GestureDetector(
                child: LayoutBuilder(builder: (context, constraint) {
              return Icon(Icons.block, size: constraint.biggest.height / 1.7);
            }), onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ArchiveDialog(chat: widget.chat));
            })),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: StreamBuilder(
                    stream: ChatService.streamMessages(widget.chat),
                    builder: (BuildContext context,
                        AsyncSnapshot<Iterable<Message>> messages) {
                      if (messages.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10.0),
                          itemBuilder: (BuildContext context, int index) =>
                              _buildMessage(messages.data!.elementAt(index)),
                          itemCount: messages.data!.length,
                          reverse: true,
                        );
                      } else {
                        return Container();
                      }
                    }),
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
                                ChatService.sendMessage(
                                    chat: widget.chat,
                                    message: Message(
                                        message: message,
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        timestamp: DateTime.now()));
                                textController.clear();
                              }
                            },
                            elevation: 2.0,
                            fillColor: Theme.of(context).colorScheme.background,
                            child: Icon(Icons.send_rounded,
                                size: 20.0,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant),
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
