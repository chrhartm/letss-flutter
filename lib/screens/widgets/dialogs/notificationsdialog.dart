import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import '../../../backend/messagingservice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsDialog extends StatelessWidget {
  final bool denied;

  const NotificationsDialog({super.key, required this.denied});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return MyDialog(
        title: AppLocalizations.of(context)!.notificationsTitle,
        content: MyDialog.textContent(AppLocalizations.of(context)!.notificationsSubtitle,
            ),
        action: () {
          denied
              ? MessagingService.openNotificationSettings().then(
                  (value) => context.mounted ? Navigator.pop(context) : null,
                )
              : MessagingService.requestPermissions().then((_) {
                  context.mounted ? Navigator.pop(context) : null;
                });
        },
        actionLabel:AppLocalizations.of(context)!.notificationsAction,
      );
    });
  }
}
