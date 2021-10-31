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
      title: 'Do you want to close this chat? ',
      content: MyDialog.TextContent(
        'You will not be able to see the messages anymore.',
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
