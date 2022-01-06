import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    Key? key,
    required this.message,
    required this.me,
  }) : super(key: key);

  final String message;
  final bool me;

  final BorderRadius meRadius = BorderRadius.only(
      topLeft: Radius.circular(18),
      bottomLeft: Radius.circular(18),
      topRight: Radius.circular(18));

  final BorderRadius youRadius = BorderRadius.only(
      topLeft: Radius.circular(18),
      bottomRight: Radius.circular(18),
      topRight: Radius.circular(18));

  final meColor = apptheme.colorScheme.primaryVariant;
  final youColor = apptheme.colorScheme.primary;

  final meTextColor = apptheme.colorScheme.onPrimary;
  final youTextColor = apptheme.colorScheme.onPrimary;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: me ? Alignment.topRight : Alignment.topLeft,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: me ? meColor : youColor,
              borderRadius: me ? meRadius : youRadius,
            ),
            child: Text(
              this.message,
              textAlign: me ? TextAlign.right : TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: me ? meTextColor : youTextColor),
            )));
  }
}
