import 'package:flutter/material.dart';
import 'tile.dart';

class TextTile extends StatelessWidget {
  const TextTile({Key? key, required this.title, required this.text})
      : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tile(
        child: Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(title, style: Theme.of(context).textTheme.headline6)),
      const SizedBox(height: 5),
      Align(
          alignment: Alignment.topLeft,
          child: Text(text, style: Theme.of(context).textTheme.bodyText1))
    ]));
  }
}
