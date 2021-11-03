import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/dialogs/myDialog.dart';
import 'package:provider/provider.dart';

import '../../../backend/analyticsservice.dart';
import '../../../provider/activitiesprovider.dart';

class LikeDialog extends StatefulWidget {
  const LikeDialog({required this.controller, Key? key}) : super(key: key);

  final AnimationController controller;

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
    String name = acts.activities.last.person.name;
    return MyDialog(
        actionLabel: "Send",
        title: "Let $name know why you'd like to join.",
        content: TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _textFieldController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(hintText: "")),
        action: () {
          if (valueText.length > 0) {
            analytics.logEvent(name: "Activity_Message");
            widget.controller.forward().whenComplete(() {
              acts.like(valueText);
              Navigator.pop(context);
            });
          }
        });
  }
}
