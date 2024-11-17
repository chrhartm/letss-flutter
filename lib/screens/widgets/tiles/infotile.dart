import 'package:flutter/material.dart';
import 'tile.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tile(
        child: Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
      const SizedBox(height: 5),
      Align(
        alignment: Alignment.topLeft,
        child: Text(text,
            strutStyle: StrutStyle(forceStrutHeight: true),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.secondary)),
      )
    ]));
  }
}
