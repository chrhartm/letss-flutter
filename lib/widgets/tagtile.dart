import 'package:flutter/material.dart';
import 'tile.dart';

class TagTile extends StatelessWidget {
  const TagTile({Key? key, required this.tags}) : super(key: key);

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    List<Widget> tag_widgets = [];

    for (int i = 0; i < tags.length; i++) {
      tag_widgets.add(Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Text('#' + tags[i],
                  style: Theme.of(context).textTheme.body2))));
      tag_widgets.add(const SizedBox(width: 5));
    }

    return Tile(
        child: Align(
            alignment: Alignment.topLeft, child: Wrap(children: tag_widgets)));
  }
}
