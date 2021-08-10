import 'package:flutter/material.dart';
import '../models/like.dart';

class ActivityLike extends StatelessWidget {
  const ActivityLike({Key? key, required this.like}) : super(key: key);

  final Like like;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.memory(like.person.pics[0],
          width: 50, height: 50, fit: BoxFit.cover),
      const SizedBox(width: 5),
      Expanded(
          child: Column(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(like.person.name + ", " + like.person.age.toString(),
                style: Theme.of(context).textTheme.headline5)),
        Align(
            alignment: Alignment.topLeft,
            child: Text(like.message,
                style: Theme.of(context).textTheme.body2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis))
      ]))
    ]);
  }
}
