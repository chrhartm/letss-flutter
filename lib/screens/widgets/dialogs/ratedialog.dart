import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:letss_app/screens/widgets/dialogs/myDialog.dart';

class RateDialog extends StatelessWidget {
  void request_review(BuildContext context) async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    }
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  void markRequested(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false).markReviewRequested();
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Short request 🙌',
      content: 'Do you enjoy this app? If so, please consider giving us ⭐⭐⭐⭐⭐',
      onA: () {
        markRequested(context);
        launch(RemoteConfigService.remoteConfig.getString("urlSupport") +
            "?subject=Feedback");
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      labelA: 'Not relly',
      onB: () {
        markRequested(context);
        request_review(context);
      },
      labelB: 'Yes',
    );
  }
}
