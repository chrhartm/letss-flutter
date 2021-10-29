import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  const MyDialog(
      {Key? key,
      required this.labelA,
      required this.labelB,
      required this.title,
      required this.content,
      required this.onA,
      required this.onB})
      : super(key: key);

  final String labelA;
  final String labelB;
  final String title;
  final String content;
  final void Function() onA;
  final void Function() onB;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.headline4),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onA,
          child: Text(labelA,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        TextButton(
          onPressed: onB,
          child: Text(labelB,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryVariant)),
        ),
      ],
    );
  }
}
