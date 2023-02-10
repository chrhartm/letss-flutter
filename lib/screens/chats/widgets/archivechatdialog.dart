import 'package:flutter/material.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/models/chat.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class ArchiveChatDialog extends StatelessWidget {
  const ArchiveChatDialog({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  void archive() {
    ChatService.archiveChat(chat);
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Do you want to block ${chat.person.name}? ',
      content: MyDialog.TextContent(
        'You will no longer receive any messages or likes from ${chat.person.name}.',
      ),
      action: () {
        archive();
        NavigatorState nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
      actionLabel: 'Yes',
    );
  }
}
