import 'package:flutter/material.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/models/chat.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaveChatDialog extends StatelessWidget {
  const LeaveChatDialog({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  void leave() {
    ChatService.leaveChat(chat);
    // Activity leaving will be synced through cloud function pushOnMessage
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: AppLocalizations.of(context)!.leaveChatDialogTitle,
      content: MyDialog.textContent(
        AppLocalizations.of(context)!.leaveChatDialogMessage,
      ),
      action: () {
        leave();
        NavigatorState nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
      actionLabel: AppLocalizations.of(context)!.leaveChatDialogAction,

    );
  }
}
