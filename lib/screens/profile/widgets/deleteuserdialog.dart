import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class DeleteUserDialog extends StatelessWidget {
  void delete(BuildContext context) {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    user.delete().then((val) => user.logout());
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Are you sure you want to delete your account?',
      content: MyDialog.TextContent(
        'All your data will be deleted. Next time you log in, you will have to start from scratch.\nIf you subscribed to support badges, please unsubscribe through the App Store or Google Play.',
      ),
      action: () {
        delete(context);
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      },
      actionLabel: 'Yes',
    );
  }
}
