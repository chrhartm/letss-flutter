import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/chat.dart';
import '../../../models/person.dart';
import '../../widgets/other/BasicListTile.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key, required this.chat, this.clickable = true})
      : super(key: key);

  final Chat chat;
  final bool clickable;

  Widget _generateThumbnail() {
    return chat.thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    bool read = chat.isRead;

    String name = chat.namePreview;

    // Get name as string variable of person who sent last message, set to "you" if by me, also check personsLeft
    String lastMessageName = "";
    if (chat.lastMessage.userId ==
        Provider.of<UserProvider>(context, listen: false).user.person.uid) {
      lastMessageName = "You";
    } else {
      Person lastMessagePerson = chat.others.firstWhere(
          (element) => element.uid == chat.lastMessage.userId,
          orElse: () => chat.personsLeft.firstWhere(
              (element) => element.uid == chat.lastMessage.userId,
              orElse: () => Person.emptyPerson()));
      lastMessageName = lastMessagePerson.name;
    }
    if (lastMessageName.length > 0) {
      lastMessageName = lastMessageName.split(" ")[0];
      lastMessageName += ": ";
    }

    return BasicListTile(
      onTap: () {
        if (this.clickable) {
          Navigator.pushNamed(context, "/chats/chat", arguments: this.chat);
        }
      },
      leading: _generateThumbnail(),
      title: name,
      subtitle: lastMessageName + chat.lastMessage.message,
      boldSubtitle: !(read || !clickable),
      primary: true,
      underlined: chat.activityData != null,
    );
  }
}
