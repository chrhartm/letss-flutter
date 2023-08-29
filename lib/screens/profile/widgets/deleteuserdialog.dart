import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class DeleteUserDialog extends StatelessWidget {
  Future<void> delete(BuildContext context) async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    await user.delete().then((val) => user.logout());
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Are you sure you want to delete your account?',
      content: MyDialog.textContent(
        'All your data will be deleted. Next time you log in, you will have to start from scratch.\nIf you subscribed to support badges, please unsubscribe through the App Store or Google Play.',
      ),
      action: () {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

        context.loaderOverlay.show();
        delete(context);
        // Will hide in welcome.dart
      },
      actionLabel: 'Yes',
    );
  }
}
