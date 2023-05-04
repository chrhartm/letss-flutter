import 'package:flutter/material.dart';
import '../../../models/chat.dart';

class ChatPreview extends StatelessWidget {
  const ChatPreview({Key? key, required this.chat, this.clickable = true})
      : super(key: key);

  final Chat chat;
  final bool clickable;

  Widget _generateThumbnail() {
    if (chat.activityData == null) {
      return chat.others[0].thumbnail;
    } else {
      return chat.activityData!.person.thumbnail;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle readstyle = Theme.of(context).textTheme.bodyMedium!;
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);
    bool read = chat.isRead;
    Widget name = Text(
        chat.activityData != null
            ? chat.activityData!.name
            : (chat.others[0].name + chat.others[0].supporterBadge),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold));

    return ListTile(
      onTap: () {
        if (this.clickable) {
          Navigator.pushNamed(context, "/chats/chat", arguments: this.chat);
        }
      },
      leading: _generateThumbnail(),
      title: name,
      subtitle: Text(chat.lastMessage.message,
          style: (read || !clickable) ? readstyle : unreadstyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }
}
