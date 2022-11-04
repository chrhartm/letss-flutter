import 'package:flutter/material.dart';
import '../screens/headerscreen.dart';

class TextHeaderScreen extends StatelessWidget {
  const TextHeaderScreen({
    Key? key,
    required this.header,
    required this.child,
    this.underline: false,
    this.back: false,
  }) : super(key: key);

  final String header;
  final Widget child;
  final bool back;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.headline1!;
    if (underline) {
      style = style.copyWith(
          color: Colors.transparent,
          shadows: [Shadow(offset: Offset(0, -2), color: style.color!)],
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.solid,
          decorationThickness: 2,
          decorationColor: Theme.of(context).colorScheme.secondaryContainer);
    }
    return HeaderScreen(
        header: Text(
          this.header,
          style: style,
        ),
        child: this.child,
        back: this.back);
  }
}
