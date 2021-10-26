import 'package:flutter/material.dart';

import 'tile.dart';
import 'package:letss_app/models/person.dart';
import '../other/supporterbadge.dart';

class NameTile extends StatelessWidget {
  const NameTile({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    List<Widget> nameRow = [
      Text(person.name + (person.age > 0 ? (", " + person.age.toString()) : ""),
          style: Theme.of(context).textTheme.headline4),
    ];
    if (person.supporter) {
      nameRow.add(SupporterBadge());
    }
    return Tile(
        child: Column(children: [
      Align(alignment: Alignment.topLeft, child: Row(children: nameRow)),
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
