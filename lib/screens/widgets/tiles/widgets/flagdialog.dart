import 'package:flutter/material.dart';
import 'package:letss_app/backend/flagservice.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/flag.dart';
import 'package:letss_app/models/person.dart';

import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FlagDialog extends StatefulWidget {
  const FlagDialog(
      {Key? key, required this.flagger, required this.flagged, this.activity})
      : super(key: key);
  final Person flagger;
  final Person flagged;
  final Activity? activity;

  @override
  FlagDialogState createState() {
    return FlagDialogState();
  }
}

class FlagDialogState extends State<FlagDialog> {
  final _textFieldController = TextEditingController();

  String message = "";
  void flag(BuildContext context) {
    Flag flag = Flag(
        flagger: widget.flagger,
        flagged: widget.flagged,
        activity: widget.activity,
        message: message);
    if (message.length > 0) {
      FlagService.flag(flag);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.flagDialogConfirmation)));
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: AppLocalizations.of(context)!.flagDialogTitle,
      content: TextField(
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          setState(() {
            message = value;
          });
        },
        controller: _textFieldController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        maxLength: 500,
        decoration: InputDecoration(counterText: "", hintText: ""),
      ),
      action: () {
        flag(context);
      },
      actionLabel: AppLocalizations.of(context)!.flagDialogAction,
    );
  }
}
