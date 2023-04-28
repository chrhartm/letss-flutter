import 'package:flutter/material.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/models/chat.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import '../../../backend/activityservice.dart';

class LeaveChatDialog extends StatelessWidget {
  const LeaveChatDialog({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  void leave() {
    ChatService.leaveChat(chat);
    if (chat.activityData != null) {
      ActivityService.leaveActivity(chat.activityData!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Do you want to leave this chat? ',
      content: MyDialog.TextContent(
        'You will no longer be able to send or receive any messages.',
      ),
      action: () {
        leave();
        NavigatorState nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
      actionLabel: 'Yes',
    );
  }
}
