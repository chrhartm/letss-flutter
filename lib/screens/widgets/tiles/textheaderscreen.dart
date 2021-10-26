import 'package:flutter/material.dart';
import '../screens/headerscreen.dart';

class TextHeaderScreen extends StatelessWidget {
  const TextHeaderScreen({
    Key? key,
    required this.header,
    required this.child,
    this.back: false,
  }) : super(key: key);

  final String header;
  final Widget child;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return HeaderScreen(
        header: Text(this.header, style: Theme.of(context).textTheme.headline1),
        child: this.child,
        back: this.back);
  }
}
