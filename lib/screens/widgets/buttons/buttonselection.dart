import 'package:flutter/material.dart';

class ButtonSelection extends StatelessWidget {
  const ButtonSelection(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.selected})
      : super(key: key);

  final String text;
  final void Function() onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    ButtonStyle selectedStyle = TextButton.styleFrom(
      textStyle: Theme.of(context).textTheme.headline3,
      primary: Theme.of(context).colorScheme.secondaryVariant,
      minimumSize: Size(double.infinity, 35),
      alignment: Alignment.center,
    );
    ButtonStyle deselectedStyle = TextButton.styleFrom(
      textStyle: Theme.of(context).textTheme.headline3,
      primary: Theme.of(context).colorScheme.secondary,
      minimumSize: Size(double.infinity, 35),
      alignment: Alignment.center,
    );
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextButton(
            onPressed: this.onPressed,
            child: Text(
              this.text,
              textAlign: TextAlign.center,
            ),
            style: selected ? selectedStyle : deselectedStyle));
  }
}
