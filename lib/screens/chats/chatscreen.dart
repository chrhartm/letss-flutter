import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/chats/profile.dart';
import 'package:letss_app/screens/chats/widgets/leavechatdialog.dart';
import '../../backend/activityservice.dart';
import '../../backend/chatservice.dart';
import '../../backend/personservice.dart';
import '../myactivities/activityscreen.dart';
import '../widgets/screens/headerscreen.dart';
import '../widgets/other/messagebubble.dart';
import '../../models/chat.dart';
import '../../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/chats/chat';

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

  bool validateMessage(String? value) {
    String val = value == null ? "" : value;
    if (val.trim() == "")
      return false;
    else
      return true;
  }

  Widget _buildMessage(Message message, bool sameSpeaker, String? speaker) {
    return Padding(
        padding: EdgeInsets.only(bottom: sameSpeaker ? 4.0 : 15.0),
        child: MessageBubble(
          message: message.message,
          me: message.userId == FirebaseAuth.instance.currentUser!.uid,
          speaker: speaker,
        ));
  }

  void block() {}

  @override
  Widget build(BuildContext context) {
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
          child: HeaderScreen(
        header:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: GestureDetector(
                  child: Text(
                    chat.activityData == null
                        ? (chat.others[0].name +
                            chat.others[0].supporterBadge)
                        : chat.activityData!.name,
                    style: Theme.of(context).textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    if (chat.activityData == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: const RouteSettings(
                                  name: '/chats/chat/profile'),
                              builder: (context) =>
                                  Profile(person: chat.others[0])));
                    } else {
                      ActivityService.getActivity(chat.activityData!.uid)
                          .then((activity) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                settings: const RouteSettings(
                                    name: '/chats/chat/activity'),
                                builder: (context) => ActivityScreen(
                                      activity: activity,
                                      mine:
                                          chat.activityData!.person.uid ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                    )));
                      });
                    }
                  })),
          GestureDetector(child: LayoutBuilder(builder: (context, constraint) {
            return Icon(Icons.block,
                color: Theme.of(context).colorScheme.secondary);
          }), onTap: () {
            showDialog(
                context: context,
                builder: (_) => LeaveChatDialog(chat: chat));
          }),
        ]),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: StreamBuilder(
                        stream: ChatService.streamMessages(chat),
                        builder: (BuildContext context,
                            AsyncSnapshot<Iterable<Message>> messages) {
                          if (messages.hasData) {
                            ChatService.markRead(chat);
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
                                if (chat.others.length > 1 &&
                                    !sameSpeaker) {
                                  Future<String> speaker =
                                      PersonService.getPerson(
                                              uid: messages.data!
                                                  .elementAt(index)
                                                  .userId)
                                          .then((value) => value.name);

                                  return FutureBuilder<String>(
                                      future: speaker,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return _buildMessage(
                                              messages.data!.elementAt(index),
                                              sameSpeaker,
                                              snapshot.data);
                                        } else {
                                          return _buildMessage(
                                              messages.data!.elementAt(index),
                                              sameSpeaker,
                                              "");
                                        }
                                      });
                                } else {
                                  return _buildMessage(
                                      messages.data!.elementAt(index),
                                      sameSpeaker,
                                      null);
                                }
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
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            decoration: BoxDecoration(
                                                color: colorScheme.primary,
                                                border: Border.all(
                                                    width: 0.0,
                                                    color:
                                                        colorScheme.background),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40.0))),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  cupertinoOverrideTheme:
                                                      NoDefaultCupertinoThemeData(
                                                          primaryColor:
                                                              colorScheme
                                                                  .onPrimary),
                                                  // This is not working but a known bug https://github.com/flutter/flutter/issues/74890
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
                                              child: TextFormField(
                                                controller: textController,
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
                                                    isDense: false,
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
                                            )))),
                                const SizedBox(width: 15),
                                RawMaterialButton(
                                    onPressed: () {
                                      if (validateMessage(
                                          textController.text)) {
                                        String message = textController.text;
                                        ChatService.sendMessage(
                                            chat: chat,
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
                                        .secondaryContainer,
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
                ])),
        back: true,
      )),
    );
  }
}
