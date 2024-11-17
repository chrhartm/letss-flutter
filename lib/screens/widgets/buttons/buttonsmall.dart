import 'package:flutter/material.dart';

class ButtonSmall extends StatelessWidget {
  const ButtonSmall({
    super.key,
    required this.text,
    this.onPressed,
    this.active = true,
    this.padding = 4.0,
  });

  final String text;
  final void Function()? onPressed;
  final bool active;
  final double padding;

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ElevatedButton(
          onPressed: active ? onPressed : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.transparent)),
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            disabledForegroundColor: colors.onSecondary,
            disabledBackgroundColor: colors.primary,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            elevation: 0,
            visualDensity: VisualDensity.compact,
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Text(
                text,
                textAlign: TextAlign.center,
              )),
        ));
  }
}
