import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  static const double buttonGap = 8;
  static const EdgeInsets buttonPadding = EdgeInsets.only(right: 8, bottom: 8);
  static const EdgeInsets buttonPaddingNoMenu =
      EdgeInsets.only(bottom: 8, right: 8); // bottom: 64 to make it level

  const ButtonAction(
      {super.key, required this.icon, this.onPressed, this.heroTag});

  final IconData icon;
  final void Function()? onPressed;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(this.icon,
        color: (heroTag != null)
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.onPrimary);
    Color backgroundColor = (heroTag != null)
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.primary;
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      heroTag: heroTag,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      elevation: 2,
      child: icon,
    );
  }
}
