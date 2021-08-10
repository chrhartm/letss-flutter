import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import '../provider/likesprovider.dart';
import '../widgets/activitylikes.dart';
import 'package:provider/provider.dart';

class Likes extends StatelessWidget {
  List<Widget> _createLikes(List<Activity> myActivities) {
    List<Widget> widgets = [];

    for (int i = 0; i < myActivities.length; i++) {
      widgets.add(ActivityLikes(activity: myActivities[i]));
    }
    return widgets;
  }

  void add() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LikesProvider>(builder: (context, likes, child) {
      return Padding(
          padding: EdgeInsets.all(20.0),
          child: Scaffold(
              body: Column(children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text("My Activities",
                        style: Theme.of(context).textTheme.headline1)),
                Column(children: _createLikes(likes.myActivities))
              ]),
              floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    add();
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))));
    });
  }
}
