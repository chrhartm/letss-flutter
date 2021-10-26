import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary(
      {Key? key, required this.text, this.onPressed, this.active = true})
      : super(key: key);

  final String text;
  final void Function()? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: this.active ? this.onPressed : null,
          child: Text(this.text),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondaryVariant,
              onPrimary: Theme.of(context).colorScheme.onSecondary,
              textStyle: Theme.of(context).textTheme.button,
              minimumSize: Size(double.infinity, 35),
              elevation: 0),
        ));
  }
}
