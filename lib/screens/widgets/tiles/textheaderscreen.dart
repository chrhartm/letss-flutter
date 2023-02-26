import 'dart:io';

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
    double underlineThickness = Platform.isIOS ? 2 : 3;
    double offsetSize = Platform.isIOS ? 1 : 2;

    TextStyle style = Theme.of(context).textTheme.displayMedium!;
    TextStyle _underlineBase = Theme.of(context).textTheme.displayLarge!;
    TextStyle underlineStyle = _underlineBase.copyWith(
        color: Colors.transparent,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: underlineThickness,
        decorationColor: Theme.of(context).colorScheme.secondaryContainer);
    TextStyle underlinedStyle = _underlineBase.copyWith(
      color: Colors.transparent,
      shadows: [Shadow(offset: Offset(0, -offsetSize), color: style.color!)],
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
