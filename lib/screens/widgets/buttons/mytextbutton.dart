import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton(
      {super.key,
      required this.text,
      this.highlighted = false,
      this.onPressed});

  final String text;
  final bool highlighted;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: highlighted
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.onSurface,
          textStyle: Theme.of(context).textTheme.displaySmall,
        ),
        child: Text(text));
  }
}
