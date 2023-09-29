import 'package:flutter/material.dart';
import 'package:letss_app/models/person.dart';

import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlockDialog extends StatefulWidget {
  const BlockDialog({Key? key, required this.blocker, required this.blocked})
      : super(key: key);
  final Person blocker;
  final Person blocked;

  @override
  BlockDialogState createState() {
    return BlockDialogState();
  }
}

class BlockDialogState extends State<BlockDialog> {
  String message = "";
  void block(BuildContext context) {
    // implement block
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!
            .blockDialogConfirmation(widget.blocked.name))));
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title:
          AppLocalizations.of(context)!.blockDialogTitle(widget.blocked.name),
      content: Text(AppLocalizations.of(context)!
          .blockDialogMessage(widget.blocked.name)),
      action: () {
        block(context);
      },
      actionLabel: AppLocalizations.of(context)!.blockDialogAction,
    );
  }
}
