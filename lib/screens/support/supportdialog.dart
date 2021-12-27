import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class SupportDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (!user.user.requestedSupport) {
        user.markSupportRequested();
      }
      return MyDialog(
        title: 'Help us pay the bills ❤️',
        content: MyDialog.TextContent(
            'Letss is not using ads or premium features. Support our mission and get a badge on your profile.'),
        action: () {
          // First close dialog
          Navigator.pop(context);
          Navigator.pushNamed(context, '/support/pitch');
        },
        actionLabel: 'Tell me more',
      );
    });
  }
}
