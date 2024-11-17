import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteUserDialog extends StatelessWidget {
  const DeleteUserDialog({super.key});
  Future<void> delete(BuildContext context) async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    await user.delete().then((val) => user.logout());
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: AppLocalizations.of(context)!.deleteUserDialogTitle,
      content: MyDialog.textContent(
        AppLocalizations.of(context)!.deleteUserDialogMessage,
      ),
      action: () {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

        context.loaderOverlay.show();
        delete(context);
        // Will hide in welcome.dart
      },
      actionLabel: AppLocalizations.of(context)!.deleteUserDialogAction,
    );
  }
}
