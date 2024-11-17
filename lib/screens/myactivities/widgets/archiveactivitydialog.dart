import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:letss_app/models/activity.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArchiveActivityDialog extends StatelessWidget {
  const ArchiveActivityDialog({super.key, required this.activity});

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
        title: AppLocalizations.of(context)!.archiveActivityDialogTitle,
        content: MyDialog.textContent(
          AppLocalizations.of(context)!.archiveActivityDialogMessage,
        ),
        action: () {
          archive(context, myActivities).then((val) {
            if (context.mounted) {  
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            }
          });
        },
        actionLabel: AppLocalizations.of(context)!.archiveActivityDialogAction,
      );
    });
  }
}
