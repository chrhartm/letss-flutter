import 'dart:io';

import 'package:flutter/material.dart';

class Underlined extends StatelessWidget {
  const Underlined(
      {Key? key,
      required this.style,
      required this.text,
      this.maxLines,
      this.overflow,
      this.underlined = true})
      : super(key: key);

  final TextStyle style;
  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool underlined;

  @override
  Widget build(BuildContext context) {
    double underlineThickness = Platform.isIOS ? 2 : 3;
    double offsetSize = Platform.isIOS ? 1 : 2;
    TextStyle _underlineBase = this.style;
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

    Text textWidget = Text(this.text,
        style: underlinedStyle,
        maxLines: this.maxLines,
        overflow: this.overflow);

    return underlined
        ? Stack(children: [
            Text(
              this.text,
              style: underlineStyle,
              maxLines: this.maxLines,
              overflow: this.overflow,
            ),
            textWidget
          ])
        : textWidget;
  }
}
