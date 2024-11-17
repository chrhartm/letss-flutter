import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Underlined extends StatelessWidget {
  const Underlined(
      {super.key,
      required this.style,
      required this.text,
      this.maxLines,
      this.overflow,
      this.underlined = true});

  final TextStyle style;
  final String text;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool underlined;

  @override
  Widget build(BuildContext context) {
    double underlineThickness = !kIsWeb && Platform.isIOS ? 2 : 3;
    double offsetSize = kIsWeb ? -1 : (Platform.isIOS ? 1 : 2);
    TextStyle underlineBase = style;
    TextStyle underlineStyle = underlineBase.copyWith(
        color: Colors.transparent,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: underlineThickness,
        decorationColor: Theme.of(context).colorScheme.secondaryContainer);
    TextStyle underlinedStyle = underlineBase.copyWith(
      color: Colors.transparent,
      shadows: [Shadow(offset: Offset(0, -offsetSize), color: style.color!)],
    );

    Text textWidget = Text(text,
        style: underlinedStyle,
        maxLines: maxLines,
        overflow: overflow);

    return underlined
        ? Stack(children: [
            Text(
              text,
              style: underlineStyle,
              maxLines: maxLines,
              overflow: overflow,
            ),
            textWidget
          ])
        : textWidget;
  }
}
