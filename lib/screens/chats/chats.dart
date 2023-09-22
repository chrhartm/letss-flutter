import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/models/message.dart';
import 'package:letss_app/models/person.dart';
import 'package:provider/provider.dart';

import '../../models/chat.dart';
import '../widgets/tiles/textheaderscreen.dart';
import 'widgets/chatpreview.dart';
import '../../provider/chatsprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/ratedialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chats extends StatelessWidget {
  Widget _buildChat(Chat chat, bool clickable) {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 2));
    widgets.add(Divider());
    widgets.add(const SizedBox(height: 2));
    widgets.add(ChatPreview(chat: chat, clickable: clickable));

    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsProvider>(builder: (context, chats, child) {
      return Scaffold(
          body: TextHeaderScreen(
        header: "Chats",
        child: StreamBuilder(
            stream: chats.chatStream,
            builder:
                (BuildContext context, AsyncSnapshot<Iterable<Chat>> chats) {
              if (chats.hasData && chats.data!.length > 0) {
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

                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) => _buildChat(
                      chats.data!.elementAt(index),
                      (chats.data!.elementAt(index).status == "ACTIVE" &&
                          (chats.data!.elementAt(index).others.length == 0 ||
                              // TOOD this needs a check
                              chats.data!.elementAt(index).others[0].uid !=
                                  "DELETED"))),
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
                    false);
              }
            }),
      ));
    });
  }
}
