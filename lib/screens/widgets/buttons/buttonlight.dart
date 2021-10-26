import 'package:flutter/material.dart';

class ButtonLight extends StatelessWidget {
  const ButtonLight(
      {Key? key, required this.text, this.onPressed, this.active = true})
      : super(key: key);

  final String text;
  final void Function()? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextButton(
            onPressed: this.active ? this.onPressed : null,
            child: Text(this.text),
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline3,
              primary: Theme.of(context).colorScheme.secondary,
              minimumSize: Size(double.infinity, 35),
              alignment: Alignment.centerLeft,
            )));
  }
}
