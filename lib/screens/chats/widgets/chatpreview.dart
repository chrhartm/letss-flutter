import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';
import 'package:provider/provider.dart';
import '../../../models/chat.dart';
import '../../../models/person.dart';

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
    TextStyle readstyle = Theme.of(context).textTheme.bodyMedium!;
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);
    bool read = chat.isRead;

    Widget name = Underlined(
        text: chat.namePreview,
        maxLines: 1,
        underlined: chat.activityData != null,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold));

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

    return ListTile(
      onTap: () {
        if (this.clickable) {
          Navigator.pushNamed(context, "/chats/chat", arguments: this.chat);
        }
      },
      leading: _generateThumbnail(),
      title: name,
      subtitle: Text(lastMessageName + chat.lastMessage.message,
          style: (read || !clickable) ? readstyle : unreadstyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
