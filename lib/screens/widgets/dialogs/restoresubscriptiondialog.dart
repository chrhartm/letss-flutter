import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import '../../../backend/StoreService.dart';
import '../../../backend/loggerservice.dart';

class RestoreSubscriptionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Badge renewal 📅',
      content: MyDialog.textContent(
          'Thanks again for supporting us! We need to quickly check your subscription status to keep it active.'),
      action: () {
        try {
          StoreService().restorePurchases();
        } catch (e) {
          LoggerService.log("Error in restoring purchase. " + e.toString(),
              level: "w");
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      actionLabel: 'Check',
    );
  }
}
