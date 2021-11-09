import 'package:flutter/material.dart';

import 'tile.dart';
import '../../../models/category.dart';
import '../../../theme/theme.dart';

class TagTile extends StatelessWidget {
  const TagTile(
      {Key? key,
      required this.tags,
      this.otherTags = const [],
      this.interests = false})
      : super(key: key);

  final List<Category> tags;
  final List<Category> otherTags;
  final bool interests;

  @override
  Widget build(BuildContext context) {
    List<Widget> tagWidgets = [];

    Set<String> othertagnames = {};

    for (int i = 0; i < otherTags.length; i++) {
      othertagnames.add(otherTags[i].name);
    }

    for (int i = 0; i < tags.length; i++) {
      String tag = tags[i].name;
      tagWidgets.add(Padding(
          padding: EdgeInsets.only(right: 8, top: 8),
          child: Chip(
              backgroundColor: othertagnames.contains(tag)
                  ? apptheme.colorScheme.primaryVariant
                  : apptheme.colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              label: Text(tag, style: Theme.of(context).textTheme.bodyText2))));
    }

    return Tile(
        child: Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(interests ? "interests" : "activity tags",
              style: Theme.of(context).textTheme.headline6)),
      Align(alignment: Alignment.topLeft, child: Wrap(children: tagWidgets)),
    ]));
  }
}
