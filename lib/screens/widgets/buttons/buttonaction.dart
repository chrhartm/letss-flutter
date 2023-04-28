import 'package:flutter/material.dart';

class ButtonAction extends StatelessWidget {
  static const double buttonGap = 8;
  static const EdgeInsets buttonPadding = EdgeInsets.only(right: 8, bottom: 8);
  static const EdgeInsets buttonPaddingNoMenu =
      EdgeInsets.only(bottom: 8, right: 8); // bottom: 64 to make it level

  const ButtonAction(
      {Key? key, required this.icon, this.onPressed, this.heroTag, this.coins})
      : super(key: key);

  final IconData icon;
  final void Function()? onPressed;
  final String? heroTag;
  final int? coins;

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(this.icon,
        color: (heroTag != null)
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.secondary);
    Color backgroundColor = (heroTag != null)
        ? Theme.of(context).colorScheme.secondaryContainer
        : Theme.of(context).colorScheme.background;
    return FloatingActionButton(
      child: (this.coins == null)
          ? icon
          : Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12, right: 8, left: 4),
                    child: icon),
                Positioned(
                    top: 3,
                    right: 0,
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (this.coins! <= 0)
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.secondary),
                        alignment: Alignment.topRight,
                        child: Text(
                          this.coins!.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold),
                        )))
              ],
            ),
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      heroTag: heroTag,
      elevation: 3,
    );
  }
}
