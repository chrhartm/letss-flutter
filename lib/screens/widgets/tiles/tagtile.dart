import 'package:flutter/material.dart';

import 'tile.dart';
import '../../../models/category.dart';
import '../../../theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TagTile extends StatelessWidget {
  const TagTile(
      {super.key,
      required this.tags,
      this.otherTags = const [],
      this.interests = false});

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
              visualDensity: VisualDensity.compact,
              labelPadding: EdgeInsets.symmetric(horizontal: 4),
              backgroundColor: othertagnames.contains(tag)
                  ? apptheme.colorScheme.primaryContainer
                  : apptheme.colorScheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // no border
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.transparent)),
              label:
                  Text(tag, style: Theme.of(context).textTheme.bodyMedium))));
    }

    return Tile(
        child: Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(
              interests
                  ? AppLocalizations.of(context)!.tagTileInterests
                  : AppLocalizations.of(context)!.tagTileTags,
              style: Theme.of(context).textTheme.titleLarge)),
      Align(alignment: Alignment.topLeft, child: Wrap(children: tagWidgets)),
    ]));
  }
}
