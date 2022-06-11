import 'package:flutter/material.dart';

class NoCards extends StatelessWidget {
  const NoCards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(height: 100),
        Text("😢", style: Theme.of(context).textTheme.headline1),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "We didn't find any activities for you.",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 100),
        Text("🤚", style: Theme.of(context).textTheme.headline1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text("Why not add some yourself?",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center),
        )
      ],
    ));
  }
}