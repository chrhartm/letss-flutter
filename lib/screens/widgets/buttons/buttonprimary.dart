import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    Key? key,
    required this.text,
    this.onPressed,
    this.active = true,
    this.secondary = false,
    this.tertiary = false,
    this.padding = 16.0,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;
  final bool active;
  final bool secondary;
  final bool tertiary;
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
              backgroundColor: this.secondary
                  ? colors.primary
                  : this.tertiary
                      ? colors.surface
                      : colors.secondaryContainer,
              foregroundColor: this.secondary
                  ? colors.secondary
                  : this.tertiary
                      ? colors.secondary
                      : colors.onSecondary,
              disabledForegroundColor: colors.onSecondary,
              disabledBackgroundColor: colors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.transparent)),
              textStyle: this.tertiary
                  ? Theme.of(context).textTheme.labelMedium!
                  : Theme.of(context).textTheme.labelLarge,
              minimumSize: Size(double.infinity, 0),
              elevation: 0),
        ));
  }
}
