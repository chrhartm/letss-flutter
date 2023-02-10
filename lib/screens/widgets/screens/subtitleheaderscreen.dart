import 'package:flutter/material.dart';
import 'headerscreen.dart';

class SubTitleHeaderScreen extends StatelessWidget {
  const SubTitleHeaderScreen({
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
    List<Widget> children = [];
    children.addAll([
      Align(
          alignment: Alignment.topLeft,
          child: Text(
              this.top == null
                  ? this.title
                  : this.title + "\u{00A0}" + this.top!,
              style: Theme.of(context).textTheme.displayLarge)),
      const SizedBox(height: 5),
      Align(
          alignment: Alignment.topLeft,
          child:
              Text(this.subtitle, style: Theme.of(context).textTheme.bodyLarge))
    ]);
    return HeaderScreen(
        header: Column(children: children), child: this.child, back: this.back);
  }
}
