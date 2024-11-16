import 'package:flutter/material.dart';

class ButtonLight extends StatelessWidget {
  const ButtonLight(
      {super.key,
      required this.text,
      this.onPressed,
      required this.icon,
      this.active = true});

  final String text;
  final IconData icon;
  final void Function()? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: [
          Expanded(
              child: TextButton(
            onPressed: active ? onPressed : null,
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.displaySmall,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              minimumSize: Size(double.infinity, 35),
              alignment: Alignment.centerLeft,
            ),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 10), child: Icon(icon)),
                Flexible(
                    child: Text(
                  text,
                  maxLines: 3,
                )),
              ],
            ),
          )),
          IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              splashColor: Colors.transparent,
              onPressed: onPressed,
              icon: Icon(Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary))
        ]));
  }
}
