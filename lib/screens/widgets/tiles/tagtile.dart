import 'package:flutter/material.dart';

import 'tile.dart';
import '../../../models/category.dart';
import '../../../theme/theme.dart';

class TagTile extends StatelessWidget {
  const TagTile({Key? key, required this.tags, this.otherTags = const []})
      : super(key: key);

  final List<Category> tags;
  final List<Category> otherTags;

  @override
  Widget build(BuildContext context) {
    List<Widget> tagWidgets = [];

    Set<String> othertagnames = {};

    for (int i = 0; i < otherTags.length; i++) {
      othertagnames.add(otherTags[i].name);
    }

    for (int i = 0; i < tags.length; i++) {
      String tag = tags[i].name;
      tagWidgets.add(Chip(
          backgroundColor: othertagnames.contains(tag)
              ? apptheme.colorScheme.primaryVariant
              : apptheme.colorScheme.primary,
          label: Text(tag, style: Theme.of(context).textTheme.bodyText2)));
      tagWidgets.add(const SizedBox(width: 10));
    }

    return Tile(
        child: Align(
            alignment: Alignment.topLeft, child: Wrap(children: tagWidgets)));
  }
}
