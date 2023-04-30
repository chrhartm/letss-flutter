import 'package:flutter/material.dart';
import 'package:letss_app/models/person.dart';

import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';

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
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.blocked.name} is blocked.")));
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Are you sure you want to block ${widget.blocked.name}?',
      content: Text(
          "Once you leave the chats with ${widget.blocked.name}, they will not be able to contact you anymore."),
      action: () {
        block(context);
      },
      actionLabel: 'Block',
    );
  }
}
