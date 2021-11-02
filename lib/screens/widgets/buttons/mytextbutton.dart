import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({Key? key, required this.text, this.onPressed})
      : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Text(text),
        onPressed: onPressed,
        style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.onBackground));
  }
}
