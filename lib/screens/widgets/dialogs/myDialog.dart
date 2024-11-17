import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({
    super.key,
    required this.actionLabel,
    required this.title,
    required this.content,
    required this.action,
    this.barrierDismissible = true,
  });

  final String actionLabel;
  final String title;
  final Widget content;
  final void Function() action;
  final bool barrierDismissible;

  void backAction(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  static Widget textContent(String content) {
    return Text(
      content,
      strutStyle: StrutStyle(forceStrutHeight: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget backButton = TextButton(
      onPressed: () {
        backAction(context);
      },
      child: Text(AppLocalizations.of(context)!.myDialogBack,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
    );
    List<Widget> buttons = [];
    if (barrierDismissible) {
      buttons.add(backButton);
    }
    buttons.add(
      TextButton(
        onPressed: action,
        child: Text(actionLabel,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondaryContainer)),
      ),
    );
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      content: content,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      actions: buttons,
    );
  }
}
