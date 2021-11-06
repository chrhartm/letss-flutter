import 'package:flutter/material.dart';

class NoActivities extends StatelessWidget {
  const NoActivities({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const SizedBox(height: 100),
        Text("😶", style: Theme.of(context).textTheme.headline1),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "You have no published activities",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 100),
        Text("😊", style: Theme.of(context).textTheme.headline1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Text("Add some so that others can like your ideas",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center),
        )
      ],
    ));
  }
}
