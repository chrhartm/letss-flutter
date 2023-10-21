import 'package:flutter/material.dart';
import 'package:letss_app/provider/connectivityprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NoConnectivityDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, conn, _child) {
      return MyDialog(
        title: AppLocalizations.of(context)!.noConnectivityTitle,
        content: MyDialog.textContent(
            AppLocalizations.of(context)!.noConnectivityMessage),
        action: () {
          conn.dialogOpen = false;
          Navigator.of(context, rootNavigator: true).pop('dialog');
          conn.notify();
        },
        actionLabel: AppLocalizations.of(context)!.noConnectivityAction,
        barrierDismissible: false,
      );
    });
  }
}
