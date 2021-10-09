import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import '../provider/myactivitiesprovider.dart';
import '../widgets/activitylikes.dart';
import '../widgets/textheaderscreen.dart';
import 'package:provider/provider.dart';
import 'editactivityname.dart';

class MyActivities extends StatelessWidget {
  List<Widget> _createMyActivities(List<Activity> myActivities) {
    List<Widget> widgets = [];

    for (int i = 0; i < myActivities.length; i++) {
      if (myActivities[i].status == 'ACTIVE') {
        widgets.add(ActivityLikes(activity: myActivities[i]));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      return Scaffold(
          body: TextHeaderScreen(
              header: "My Activities",
              child: ListView(
                  children: _createMyActivities(myActivities.myActivities))),
          floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        myActivities.loadMyActivities();
                      },
                      child: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      heroTag: null,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                        onPressed: () {
                          myActivities.editActiviyUid = null;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditActivityName()));
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ))
                  ])));
    });
  }
}
