import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;

  const TextDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerLeft, children: [
      Divider(thickness: 1, height: 1),
      Padding(
          padding: EdgeInsets.only(left: 8),
          // fill the background with the background color
          child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  )))),
    ]);
  }
}
