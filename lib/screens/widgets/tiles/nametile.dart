import 'package:flutter/material.dart';

import 'tile.dart';
import 'package:letss_app/models/person.dart';

class NameTile extends StatelessWidget {
  const NameTile({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    Widget name = Text(
        person.name +
            (person.age > 0 ? (", " + person.age.toString()) : "") +
            person.supporterBadge,
        style: Theme.of(context).textTheme.headline4);

    return Tile(
        child: Column(children: [
      Align(alignment: Alignment.topLeft, child: name),
      const SizedBox(height: 5),
      Align(
          alignment: Alignment.topLeft,
          child: Text(
              person.job +
                  (person.job != "" && person.locationString != ""
                      ? ", "
                      : "") +
                  person.locationString,
              style: Theme.of(context).textTheme.bodyText1)),
    ]));
  }
}
