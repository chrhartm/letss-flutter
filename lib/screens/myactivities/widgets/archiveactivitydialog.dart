import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:letss_app/models/activity.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class ArchiveActivityDialog extends StatelessWidget {
  const ArchiveActivityDialog({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  Future archive(
      BuildContext context, MyActivitiesProvider myActivities) async {
    await myActivities.archive(activity);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return MyDialog(
        title: 'Do you want to close this idea?',
        content: MyDialog.textContent(
          "You will not see it in the overview anymore and others won't see it suggested to them. Your chat will stay open.",
        ),
        action: () {
          archive(context, myActivities).then((val) {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          });
        },
        actionLabel: 'Yes',
      );
    });
  }
}
