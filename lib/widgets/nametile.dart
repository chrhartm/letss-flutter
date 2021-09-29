import 'package:flutter/material.dart';
import 'tile.dart';

class NameTile extends StatelessWidget {
  const NameTile(
      {Key? key,
      required this.name,
      required this.age,
      required this.job,
      required this.location})
      : super(key: key);

  final String name;
  final int age;
  final String job;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Tile(
        child: Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(name + (age > 0 ? (", " + age.toString()) : ""),
              style: Theme.of(context).textTheme.headline4)),
      const SizedBox(height: 5),
      Align(
          alignment: Alignment.topLeft,
          child: Text(
              job + (job != "" && location != "" ? ", " : "") + location,
              style: Theme.of(context).textTheme.body1)),
    ]));
  }
}
