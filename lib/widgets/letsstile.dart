import 'package:flutter/material.dart';
import 'tile.dart';

// TODO deprecate
class LetssTile extends StatelessWidget {
  const LetssTile({
    Key? key,
    required this.activityName,
  }) : super(key: key);

  final String activityName;

  @override
  Widget build(BuildContext context) {
    return Tile(
        child: Row(children: [
      Expanded(
          child:
              Text(activityName, style: Theme.of(context).textTheme.headline1))
    ]));
  }
}
