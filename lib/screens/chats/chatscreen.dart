import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/chats/widgets/leavechatdialog.dart';
import 'package:provider/provider.dart';
import '../../backend/activityservice.dart';
import '../../backend/chatservice.dart';
import '../../models/person.dart';
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
  bool blocked = true;
  bool checkedBlocked = false;

  @override
  void initState() {
    super.initState();
  }

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

  Widget _buildMessage(
      {required Message message,
      required Person speaker,
      bool lastMessage = false,
      bool firstMessage = false}) {
    return Padding(
        padding: EdgeInsets.only(bottom: (lastMessage) ? 15.0 : 4.0),
        child: MessageBubble(
          message: message.message,
          me: message.userId == FirebaseAuth.instance.currentUser!.uid,
          speaker: speaker,
          firstMessage: firstMessage,
          lastMessage: lastMessage,
        ));
  }

  void initBlocked(Chat chat) {
    chat.others.forEach((person) {
      UserProvider.blockedMe(person).then((blocked) {
        if (blocked) {
          setState(() {
            blocked = true;
            checkedBlocked = true;
          });
        }
      }).then((value) => setState(() {
            if (!checkedBlocked) {
              blocked = false;
              checkedBlocked = true;
            }
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    if (!checkedBlocked) {
      initBlocked(chat);
    }

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Person myPerson =
        Provider.of<UserProvider>(context, listen: false).user.person;

    return Scaffold(
      body: SafeArea(
          child: HeaderScreen(
        header:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: GestureDetector(
                  child: Text(
                    chat.activityData == null
                        ? (chat.others[0].name + chat.others[0].supporterBadge)
                        : chat.activityData!.name,
                    style: Theme.of(context).textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    if (chat.activityData == null) {
                      Navigator.pushNamed(context, '/profile/person',
                          arguments: chat.others[0]);
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
                                      mine: chat.activityData!.person.uid ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                    )));
                      });
                    }
                  })),
          GestureDetector(child: LayoutBuilder(builder: (context, constraint) {
            return Icon(Icons.horizontal_rule,
                color: Theme.of(context).colorScheme.secondary);
          }), onTap: () {
            showDialog(
                context: context, builder: (_) => LeaveChatDialog(chat: chat));
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
                                Message message =
                                    messages.data!.elementAt(index);
                                Person speaker = myPerson;
                                if (message.userId != myPerson.uid) {
                                  speaker = chat.others.firstWhere(
                                      (element) =>
                                          element.uid == message.userId,
                                      orElse: () => chat.othersLeft.firstWhere(
                                          (element) =>
                                              element.uid == message.userId,
                                          orElse: () => Person.emptyPerson(
                                              name: "Unknown")));
                                }
                                bool lastMessage = true;
                                if (index >= 1 &&
                                    messages.data!
                                            .elementAt(index - 1)
                                            .userId ==
                                        message.userId) {
                                  lastMessage = false;
                                }
                                bool firstMessage = false;
                                if (index == messages.data!.length - 1 ||
                                    (index < messages.data!.length - 1 &&
                                        message.userId !=
                                            messages.data!
                                                .elementAt(index + 1)
                                                .userId)) {
                                  firstMessage = true;
                                }

                                return _buildMessage(
                                    message: message,
                                    firstMessage: firstMessage,
                                    lastMessage: lastMessage,
                                    speaker: speaker);
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
                                              textController.text) &&
                                          !blocked) {
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
