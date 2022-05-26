import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/widgets/dialogs/myDialog.dart';
import 'package:provider/provider.dart';

import '../../../backend/analyticsservice.dart';
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
    String name = widget.activity.person.name;
    return MyDialog(
        actionLabel: "Send",
        title: "Let $name know why you'd like to join.",
        content: TextField(
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
        ),
        action: () {
          if (valueText.length > 0) {
            analytics.logEvent(name: "Activity_Message");
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
          }
        });
  }
}
