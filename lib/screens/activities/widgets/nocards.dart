import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../backend/analyticsservice.dart';
import '../../../provider/activitiesprovider.dart';
import '../../../provider/myactivitiesprovider.dart';
import '../../widgets/buttons/buttonprimary.dart';

class NoCards extends StatelessWidget {
  const NoCards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("👀", style: Theme.of(context).textTheme.headline1),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "You've seen all activities nearby.",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonPrimary(
                text: "Add your own activity",
                active: true,
                padding: 0,
                onPressed: () {
                  Provider.of<MyActivitiesProvider>(context, listen: false)
                      .addNewActivity(context);
                  analytics.logEvent(name: "Add_Activity_Empty");
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonPrimary(
                text: "Browse activity ideas",
                secondary: true,
                padding: 0,
                active: true,
                onPressed: () {
                  Navigator.pushNamed(context, "/myactivities/templates");
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonPrimary(
                text: "Review skipped ones",
                secondary: true,
                padding: 0,
                active: !activities.gettingActivities,
                onPressed: () {
                  activities.promptPass();
                }),
          ),
        ],
      ));
    });
  }
}
