import 'package:flutter/material.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/models/chat.dart';
import 'package:letss_app/screens/widgets/dialogs/myDialog.dart';

class ArchiveDialog extends StatelessWidget {
  const ArchiveDialog({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  void archive() {
    ChatService.archiveChat(chat);
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Close chat',
      content:
          'Are you sure you want to close this chat? You will not be able to see the messages anymore.',
      onA: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      labelA: 'Back',
      onB: () {
        archive();
        NavigatorState nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
      labelB: 'Yes',
    );
  }
}
