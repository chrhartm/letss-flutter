import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:provider/provider.dart';

import '../../../models/activity.dart';
import '../../../models/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RemoveParticipantDialog extends StatelessWidget {
  const RemoveParticipantDialog(
      {Key? key, required this.participant, required this.activity})
      : super(key: key);

  final Person participant;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: AppLocalizations.of(context)!.removeParticipantDialogTitle(participant.name),
      content: MyDialog.textContent(
        AppLocalizations.of(context)!.removeParticipantDialogMessage,
      ),
      action: () {
        Provider.of<MyActivitiesProvider>(context, listen: false)
            .removeParticipant(activity: activity, person: participant);
        NavigatorState nav = Navigator.of(context);
        nav.pop();
      },
      actionLabel: AppLocalizations.of(context)!.removeParticipantDialogAction,
    );
  }
}
