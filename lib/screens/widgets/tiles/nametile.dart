import 'package:flutter/material.dart';

import 'tile.dart';
import 'package:letss_app/models/person.dart';

class NameTile extends StatelessWidget {
  const NameTile(
      {Key? key,
      required this.person,
      this.otherLocation = null,
      this.padding = true})
      : super(key: key);

  final bool padding;
  final Person person;
  final Map<String, dynamic>? otherLocation;

  @override
  Widget build(BuildContext context) {
    Widget name = Text(
        person.name +
            (person.age > 0 ? (", " + person.age.toString()) : "") +
            person.supporterBadge,
        style: Theme.of(context).textTheme.headlineMedium);

    return Tile(
        padding: this.padding,
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
                      person.distanceString(otherLocation, reverse: false),
                  style: Theme.of(context).textTheme.bodyLarge)),
        ]));
  }
}
