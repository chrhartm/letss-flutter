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
        textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              decoration: TextDecoration.underline,
            ),
        minimumSize: Size(double.infinity, 35),
        alignment: Alignment.center,
        foregroundColor: Theme.of(context).colorScheme.secondaryContainer);
    ButtonStyle deselectedStyle = TextButton.styleFrom(
      textStyle: Theme.of(context).textTheme.displaySmall,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      minimumSize: Size(double.infinity, 35),
      alignment: Alignment.center,
    );
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: TextButton(
            onPressed: this.onPressed,
            child: Text(
              this.text,
              textAlign: TextAlign.center,
            ),
            style: selected ? selectedStyle : deselectedStyle));
  }
}
