import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import '../../backend/messagingservice.dart';

class NotificationsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return MyDialog(
        title: 'Turn on notifications?',
        content: MyDialog.TextContent(
            "Never miss a message in chat or a new idea from your friends"),
        action: () {
          MessagingService.requestPermissions().then((_) {
            Navigator.pop(context);
          });
        },
        actionLabel: 'Turn on',
      );
    });
  }
}
