import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import '../../../backend/StoreService.dart';
import '../../../backend/loggerservice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RestoreSubscriptionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: AppLocalizations.of(context)!.restoreSubscriptionTitle,
      content: MyDialog.textContent(
          AppLocalizations.of(context)!.restoreSubscriptionMessage),
      action: () {
        try {
          StoreService().restorePurchases();
        } catch (e) {
          LoggerService.log("Error in restoring purchase. " + e.toString(),
              level: "w");
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      actionLabel: AppLocalizations.of(context)!.restoreSubscriptionAction,
    );
  }
}
