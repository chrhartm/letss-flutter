import 'package:flutter/material.dart';
import 'package:letss_app/backend/genericconfigservice.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportDialog extends StatelessWidget {
  const SupportDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (!user.user.requestedSupport) {
        user.markSupportRequested();
      }

      return MyDialog(
        title: AppLocalizations.of(context)!.supportDialogTitle,
        content: MyDialog.textContent(
            GenericConfigService.config.getString("supportPitch")),
        action: () {
          // first close dialog
          Navigator.pop(context);
          Navigator.pushNamed(context, '/support/pitch');
        },
        actionLabel: AppLocalizations.of(context)!.supportDialogAction,
      );
    });
  }
}
