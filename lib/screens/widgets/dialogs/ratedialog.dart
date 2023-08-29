import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class RateDialog extends StatelessWidget {
  void requestReview(BuildContext context) async {
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
      content: MyDialog.textContent(
          'Do you enjoy this app? If so, please consider rating us on the store. We would really appreciate it!'),
      action: () {
        requestReview(context);
      },
      actionLabel: 'Yes',
    );
  }
}
