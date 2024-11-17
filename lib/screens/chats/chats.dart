import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/models/message.dart';
import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import 'widgets/chatpreview.dart';
import '../../provider/chatsprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chats extends StatelessWidget {
  final String? chatId;

  const Chats({super.key, this.chatId});

  Widget _buildChat(Chat chat, bool clickable, BuildContext context) {
    return ChatPreview(chat: chat, clickable: clickable);
  }

  @override
  Widget build(BuildContext context) {
    if (chatId != null) {
      String chatId = this.chatId!;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        final chat = await ChatService.getChat(chatId: chatId);
        if (context.mounted) {
          Navigator.pushNamed(context, '/chats/chat', arguments: chat);
        }
      });
    }
    return Consumer<ChatsProvider>(builder: (context, chats, child) {
      return Scaffold(
          body: HeaderScreen(
        title: AppLocalizations.of(context)!.chatsTitle,
        child: StreamBuilder(
            stream: chats.chatStream,
            builder:
                (BuildContext context, AsyncSnapshot<Iterable<Chat>> chats) {
              if (chats.hasData && chats.data!.isNotEmpty) {
                // No review dialog for now
                /*
                if (chats.data!.length >
                        ConfigService.config.minChatsForReview &&
                    (Provider.of<UserProvider>(context, listen: false)
                            .user
                            .requestedReview ==
                        false)) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return RateDialog();
                        });
                  });
                }
                */

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) => _buildChat(
                      chats.data!.elementAt(index),
                      (chats.data!.elementAt(index).status == "ACTIVE" &&
                          (chats.data!.elementAt(index).others.isEmpty ||
                              // TOOD this needs a check
                              chats.data!.elementAt(index).others[0].uid !=
                                  "DELETED")),
                      context),
                  itemCount: chats.data!.length,
                  reverse: false,
                );
              } else if (chats.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return _buildChat(
                    Chat(
                        others: [
                          Person.emptyPerson(
                              name: AppLocalizations.of(context)!
                                  .noChatPersonName)
                        ],
                        personsLeft: [],
                        uid: "",
                        status: 'ACTIVE',
                        lastMessage: Message(
                            message:
                                AppLocalizations.of(context)!.noChatMessage,
                            // different userId than empty Person for read logic
                            userId: "x",
                            timestamp: DateTime.now()),
                        read: [""]),
                    false,
                    context);
              }
            }),
      ));
    });
  }
}
