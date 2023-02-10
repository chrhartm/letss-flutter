import 'package:flutter/material.dart';
import '../screens/headerscreen.dart';

class TextHeaderScreen extends StatelessWidget {
  const TextHeaderScreen({
    Key? key,
    required this.header,
    required this.child,
    this.underline = false,
    this.back = false,
  }) : super(key: key);

  final String header;
  final Widget child;
  final bool back;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.displayLarge!;
    TextStyle underlineStyle = style.copyWith(
        color: Colors.transparent,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 2,
        decorationColor: Theme.of(context).colorScheme.secondaryContainer);
    TextStyle underlinedStyle = style.copyWith(
      color: Colors.transparent,
      shadows: [Shadow(offset: Offset(0, -1), color: style.color!)],
    );
    return HeaderScreen(
        header: underline
            ? Stack(children: [
                Text(this.header, style: underlineStyle),
                Text(this.header, style: underlinedStyle)
              ])
            : Text(
                this.header,
                style: style,
              ),
        child: this.child,
        back: this.back);
  }
}
