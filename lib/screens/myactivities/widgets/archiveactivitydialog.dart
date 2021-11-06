import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:letss_app/models/activity.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

class ArchiveChatDialog extends StatelessWidget {
  const ArchiveChatDialog({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  Future archive(
      BuildContext context, MyActivitiesProvider myActivities) async {
    myActivities.editActiviyUid = activity.uid;
    analytics.logEvent(name: "MyActivity_Archive");
    await myActivities.updateActivity(status: 'ARCHIVED');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return MyDialog(
        title: 'Do you want to close this activity?',
        content: MyDialog.TextContent(
          "You will not see it in the overview anymore and others won't see it suggested to them.",
        ),
        action: () {
          archive(context, myActivities).then((val) {
            NavigatorState nav = Navigator.of(context);
            nav.pop();
            nav.pop();
          });
        },
        actionLabel: 'Yes',
      );
    });
  }
}
