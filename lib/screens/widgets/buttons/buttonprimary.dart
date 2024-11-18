import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({
    super.key,
    required this.text,
    this.onPressed,
    this.active = true,
    this.secondary = false,
    this.tertiary = false,
    this.padding = 16.0,
    this.icon,
  });

  final String text;
  final void Function()? onPressed;
  final bool active;
  final bool secondary;
  final bool tertiary;
  final double padding;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: ElevatedButton(
          onPressed: active ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: secondary
                ? colors.primary
                : tertiary
                    ? colors.surface
                    : colors.secondaryContainer,
            foregroundColor: secondary
                ? colors.secondary
                : tertiary
                    ? colors.secondary
                    : colors.onSecondary,
            disabledForegroundColor: colors.onSecondary,
            disabledBackgroundColor: colors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.transparent)),
            textStyle: tertiary
                ? Theme.of(context).textTheme.labelMedium!
                : Theme.of(context).textTheme.labelLarge,
            minimumSize: Size(double.infinity, 0),
            elevation: 0,
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                icon != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: icon)
                    : Container(height: 0),
                Text(
                  text,
                  textAlign: TextAlign.center,
                )
              ])),
        ));
  }
}
