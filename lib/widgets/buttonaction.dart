import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  static const double buttonGap = 8;
  static const EdgeInsets buttonPadding = EdgeInsets.only(right: 8, bottom: 8);
  static const EdgeInsets buttonPaddingNoMenu =
      EdgeInsets.only(bottom: 64, right: 8);

  const ButtonAction(
      {Key? key,
      required this.icon,
      this.onPressed,
      this.hero = true,
      this.text})
      : super(key: key);

  final IconData icon;
  final void Function()? onPressed;
  final bool? hero;
  final String? text;

  @override
  Widget build(BuildContext context) {
    Icon icon =
        Icon(this.icon, color: Theme.of(context).colorScheme.onSecondary);
    Color backgroundColor = (hero == true)
        ? Theme.of(context).colorScheme.secondaryVariant
        : Theme.of(context).colorScheme.secondary;
    return FloatingActionButton(
      child: (text == null)
          ? icon
          : Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                    child: icon),
                Positioned(
                    top: -3,
                    right: 0,
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.secondary),
                        alignment: Alignment.topRight,
                        child: Text(
                          this.text!,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold),
                        )))
              ],
            ),
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      heroTag: hero,
    );
  }
}
