import 'package:flutter/material.dart';
import 'headerscreen.dart';

// TODO eventually just replace with HeaderScreen
class SubtitleHeaderScreen extends StatelessWidget {
  const SubtitleHeaderScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.top,
    this.back = false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String? top;
  final Widget child;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return HeaderScreen(
        title: this.title,
        subtitle: this.subtitle,
        child: this.child,
        top: this.top,
        back: this.back);
  }
}
