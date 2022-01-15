import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
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
      analytics.logEvent(name: "Request_Support");

      return MyDialog(
        title: 'Help us pay the bills ❤️',
        content: MyDialog.TextContent(
            RemoteConfigService.remoteConfig.getString('supportPitch')),
        action: () {
          analytics.logEvent(name: "View_Support_Pitch");
          // first close dialog
          Navigator.pop(context);
          Navigator.pushNamed(context, '/support/pitch');
        },
        actionLabel: 'Tell me more',
      );
    });
  }
}
