import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({
    Key? key,
    required this.actionLabel,
    required this.title,
    required this.content,
    required this.action,
  }) : super(key: key);

  final String actionLabel;
  final String title;
  final Widget content;
  final void Function() action;

  void backAction(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  static Widget TextContent(String content) {
    return Text(content, strutStyle: StrutStyle(forceStrutHeight: true),);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.headline4),
      content: content,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            backAction(context);
          },
          child: Text("Back",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        TextButton(
          onPressed: action,
          child: Text(actionLabel,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryVariant)),
        ),
      ],
    );
  }
}
