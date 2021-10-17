import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  const ButtonAction(
      {Key? key, required this.icon, this.onPressed, this.hero = true})
      : super(key: key);

  final IconData icon;
  final void Function()? onPressed;
  final bool? hero;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
      heroTag: hero,
      backgroundColor: (hero == true)
          ? Theme.of(context).colorScheme.secondaryVariant
          : Theme.of(context).colorScheme.secondary,
    );
  }
}
