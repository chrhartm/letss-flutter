import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

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
    markRequested(context);
    return MyDialog(
      title: 'Short request 🙌',
      content: MyDialog.TextContent(
          'Do you enjoy this app? If so, please consider giving us ⭐⭐⭐⭐⭐'),
      action: () {
        request_review(context);
      },
      actionLabel: 'Yes',
    );
  }
}
