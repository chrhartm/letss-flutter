import 'package:flutter/material.dart';
import '../screens/headerscreen.dart';

// TODO eventually just replace with HeaderScreen
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
    return HeaderScreen(
        title: header,
        underlined: underline,
        child: this.child,
        back: this.back);
  }
}
