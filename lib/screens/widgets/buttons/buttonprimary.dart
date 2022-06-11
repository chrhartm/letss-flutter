import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    Key? key,
    required this.text,
    this.onPressed,
    this.active = true,
    this.secondary = false,
    this.padding = 16.0,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;
  final bool active;
  final bool secondary;
  final double padding;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: this.padding),
        child: ElevatedButton(
          onPressed: this.active ? this.onPressed : null,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                this.text,
                textAlign: TextAlign.center,
              )),
          style: ElevatedButton.styleFrom(
              primary:
                  this.secondary ? colors.secondary : colors.secondaryVariant,
              onPrimary:
                  this.secondary ? colors.onSecondary : colors.onSecondary,
              textStyle: Theme.of(context).textTheme.button,
              minimumSize: Size(double.infinity, 0),
              elevation: 0),
        ));
  }
}
