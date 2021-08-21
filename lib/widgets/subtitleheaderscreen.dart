import 'package:flutter/material.dart';
import '../widgets/headerscreen.dart';

class SubTitleHeaderScreen extends StatelessWidget {
  const SubTitleHeaderScreen({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.back: false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Widget child;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return HeaderScreen(
        header: Column(children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(this.title,
                  style: Theme.of(context).textTheme.headline1)),
          const SizedBox(height: 5),
          Align(
              alignment: Alignment.topLeft,
              child: Text(this.subtitle,
                  style: Theme.of(context).textTheme.bodyText1))
        ]),
        child: this.child,
        back: this.back);
  }
}
