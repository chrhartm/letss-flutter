import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:letss_app/provider/userprovider.dart';

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
    return AlertDialog(
      title: Text('Short request 🙌',
          style: Theme.of(context).textTheme.headline4),
      content:
          Text('Do you enjoy this app? If so, please consider giving us ⭐⭐⭐⭐⭐'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            markRequested(context);
            launch(RemoteConfigService.remoteConfig.getString("urlSupport") +
                "?subject=Feedback");
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text('Not relly',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        TextButton(
          onPressed: () {
            markRequested(context);
            request_review(context);
          },
          child: Text('Yes',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryVariant)),
        ),
      ],
    );
  }
}
