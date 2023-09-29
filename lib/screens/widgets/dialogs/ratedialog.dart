import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      title: AppLocalizations.of(context)!.rateDialogTitle,
      content: MyDialog.textContent(
          AppLocalizations.of(context)!.rateDialogMessage,),
      action: () {
        requestReview(context);
      },
      actionLabel: AppLocalizations.of(context)!.rateDialogAction,
    );
  }
}
