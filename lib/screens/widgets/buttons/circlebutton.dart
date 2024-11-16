import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {super.key,
      required this.icon,
      this.onPressed,
      this.highlighted = false});

  final IconData icon;
  final void Function()? onPressed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: highlighted
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.primary,
        shape: CircleBorder(),
        child: IconButton(
          icon: Icon(icon, size: 16),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onPressed: onPressed,
          color: highlighted
              ? Theme.of(context).colorScheme.onSecondaryContainer
              : Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
