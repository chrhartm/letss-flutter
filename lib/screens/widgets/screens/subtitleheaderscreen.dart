import 'package:flutter/material.dart';
import 'headerscreen.dart';

class SubTitleHeaderScreen extends StatelessWidget {
  const SubTitleHeaderScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.top,
    this.back: false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String? top;
  final Widget child;
  final bool back;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (top != null) {
      children.add(Align(
          alignment: Alignment.topLeft,
          child:
              Text(this.top!, style: Theme.of(context).textTheme.headline1)));
      children.add(const SizedBox(height: 5));
    }
    children.addAll([
      Align(
          alignment: Alignment.topLeft,
          child:
              Text(this.title, style: Theme.of(context).textTheme.headline1)),
      const SizedBox(height: 5),
      Align(
          alignment: Alignment.topLeft,
          child:
              Text(this.subtitle, style: Theme.of(context).textTheme.bodyText1))
    ]);
    return HeaderScreen(
        header: Column(children: children), child: this.child, back: this.back);
  }
}
