import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../provider/activitiesprovider.dart';

class LikeDialog extends StatefulWidget {
  const LikeDialog({required this.activity, required this.controller, Key? key})
      : super(key: key);

  final AnimationController? controller;
  final Activity activity;

  @override
  LikeDialogState createState() {
    return LikeDialogState();
  }
}

class LikeDialogState extends State<LikeDialog> {
  final _textFieldController = TextEditingController();

  String codeDialog = "";
  String valueText = "";

  @override
  Widget build(BuildContext context) {
    ActivitiesProvider acts =
        Provider.of<ActivitiesProvider>(context, listen: false);
    return MyDialog(
        actionLabel: AppLocalizations.of(context)!.likeDialogAction,
        title: AppLocalizations.of(context)!.likeDialogTitle,
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
                AppLocalizations.of(context)!.likeDialogSubtitle(widget.activity.person.name),
                style: Theme.of(context).textTheme.bodySmall),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            maxLength: 200,
            decoration: InputDecoration(counterText: "", hintText: ""),
            controller: _textFieldController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 10,
            textCapitalization: TextCapitalization.sentences,
          )
        ]),
        action: () {
          if (widget.controller == null) {
            acts.like(activity: widget.activity, message: valueText.trim());
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            widget.controller!.forward().whenComplete(() {
              acts.like(activity: widget.activity, message: valueText.trim());
              Navigator.pop(context);
            });
          }
        });
  }
}
