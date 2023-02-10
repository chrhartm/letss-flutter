import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton(
      {Key? key, required this.text, this.highlighted = false, this.onPressed})
      : super(key: key);

  final String text;
  final bool highlighted;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Text(text),
        onPressed: onPressed,
        style: TextButton.styleFrom(
            foregroundColor: highlighted
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.onBackground,
            textStyle: Theme.of(context).textTheme.displaySmall));
  }
}
