import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import '../../backend/messagingservice.dart';

class NotificationsDialog extends StatelessWidget {
  final bool denied;

  NotificationsDialog(this.denied);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return MyDialog(
        title: 'Turn on notifications',
        content: MyDialog.textContent(
            "Get notified about messages and new ideas from your friends"),
        action: () {
          denied
              ? MessagingService.openNotificationSettings().then(
                  (value) => Navigator.pop(context),
                )
              : MessagingService.requestPermissions().then((_) {
                  Navigator.pop(context);
                });
        },
        actionLabel: 'Turn on',
      );
    });
  }
}
