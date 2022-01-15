import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/chats/profile.dart';
import 'package:letss_app/screens/chats/widgets/archivechatdialog.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
  bool emojiShowing = false;

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

  Widget _buildMessage(Message message, bool sameSpeaker) {
    return Padding(
        padding: EdgeInsets.only(bottom: sameSpeaker ? 4.0 : 15.0),
        child: MessageBubble(
            message: message.message,
            me: message.userId == FirebaseAuth.instance.currentUser!.uid));
  }

  _onEmojiSelected(Emoji emoji) {
    textController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
  }

  _onBackspacePressed() {
    textController
      ..text = textController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
  }

  void block() {}

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: HeaderScreen(
        header:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
              child: Text(
                  widget.chat.person.name + widget.chat.person.supporterBadge,
                  style: Theme.of(context).textTheme.headline1),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings:
                            const RouteSettings(name: '/chats/chat/profile'),
                        builder: (context) =>
                            Profile(person: widget.chat.person)));
              }),
          GestureDetector(child: LayoutBuilder(builder: (context, constraint) {
            return Icon(Icons.block,
                color: Theme.of(context).colorScheme.secondary);
          }), onTap: () {
            showDialog(
                context: context,
                builder: (_) => ArchiveChatDialog(chat: widget.chat));
          }),
        ]),
        child: GestureDetector(
            onTap: () {
              setState(() {
                emojiShowing = false;
              });
              FocusScope.of(context).requestFocus(new FocusNode());
            },
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
                            ChatService.markRead(widget.chat);
                            return ListView.builder(
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              itemBuilder: (BuildContext context, int index) {
                                bool sameSpeaker = false;
                                if (index >= 1 &&
                                    messages.data!
                                            .elementAt(index - 1)
                                            .userId ==
                                        messages.data!
                                            .elementAt(index)
                                            .userId) {
                                  sameSpeaker = true;
                                }
                                return _buildMessage(
                                    messages.data!.elementAt(index),
                                    sameSpeaker);
                              },
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
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Container(
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            color: colorScheme.primary,
                                            border: Border.all(
                                                width: 0.0,
                                                color: colorScheme.background),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40.0))),
                                        child: Row(children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              setState(() {
                                                emojiShowing = !emojiShowing;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.emoji_emotions_outlined,
                                              color: colorScheme.onPrimary,
                                            ),
                                          ),
                                          Theme(
                                            data: Theme.of(context).copyWith(
                                                cupertinoOverrideTheme:
                                                    NoDefaultCupertinoThemeData(
                                                        primaryColor: colorScheme
                                                            .onPrimary),
                                                // TODO this is not working but a known bug https://github.com/flutter/flutter/issues/74890
                                                textSelectionTheme: Theme.of(
                                                        context)
                                                    .textSelectionTheme
                                                    .copyWith(
                                                        selectionHandleColor:
                                                            colorScheme
                                                                .onPrimary,
                                                        selectionColor:
                                                            colorScheme
                                                                .onPrimary
                                                                .withOpacity(
                                                                    0.3))),
                                            child: Expanded(
                                              child: TextFormField(
                                                onTap: () => setState(() {
                                                  emojiShowing = false;
                                                }),
                                                controller: textController,
                                                validator: validateMessage,
                                                maxLines: 5,
                                                minLines: 1,
                                                maxLength: 500,
                                                showCursor: true,
                                                cursorColor:
                                                    colorScheme.onPrimary,
                                                autofocus: false,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: "Aa",
                                                    counterText: ""),
                                              ),
                                            ),
                                          )
                                        ])))),
                            const SizedBox(width: 15),
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
                                elevation: 0.0,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryVariant,
                                child: Icon(Icons.send,
                                    size: 25.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                constraints: BoxConstraints())
                          ]))),
                  Offstage(
                    offstage: !emojiShowing,
                    child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                          onEmojiSelected: (Category category, Emoji emoji) {
                            _onEmojiSelected(emoji);
                          },
                          onBackspacePressed: _onBackspacePressed,
                          config: Config(
                              columns: 7,
                              // Issue: https://github.com/flutter/flutter/issues/28894
                              emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                              verticalSpacing: 0,
                              horizontalSpacing: 0,
                              initCategory: Category.RECENT,
                              bgColor: colorScheme.background,
                              indicatorColor: colorScheme.secondaryVariant,
                              iconColor: colorScheme.secondary,
                              iconColorSelected: colorScheme.secondaryVariant,
                              progressIndicatorColor: colorScheme.secondary,
                              backspaceColor: colorScheme.secondary,
                              showRecentsTab: true,
                              recentsLimit: 28,
                              noRecentsText: 'No Recents',
                              noRecentsStyle: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: colorScheme.primary),
                              tabIndicatorAnimDuration: kTabScrollDuration,
                              categoryIcons: const CategoryIcons(),
                              buttonMode: ButtonMode.MATERIAL)),
                    ),
                  )
                ])),
        back: true,
      )),
    );
  }
}
