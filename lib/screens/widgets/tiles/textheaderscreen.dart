import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';
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
    TextStyle style = Theme.of(context).textTheme.displayMedium!;

    return HeaderScreen(
        header: underline
            ? Underlined(
                text: this.header,
                style: Theme.of(context).textTheme.displayLarge!)
            : Text(
                this.header,
                style: style,
              ),
        child: this.child,
        back: this.back);
  }
}
