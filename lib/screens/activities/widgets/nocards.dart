import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../../provider/activitiesprovider.dart';
import '../../../provider/myactivitiesprovider.dart';
import '../../../provider/userprovider.dart';
import '../../widgets/buttons/buttonprimary.dart';

class NoCards extends StatelessWidget {
  const NoCards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String location = Provider.of<UserProvider>(context, listen: false)
        .user
        .person
        .locationString;
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("👀", style: Theme.of(context).textTheme.displayMedium),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "You've seen all ideas in $location.",
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonPrimary(
                text: "Add your own idea",
                active: true,
                padding: 0,
                onPressed: () {
                  Provider.of<MyActivitiesProvider>(context, listen: false)
                      .addNewActivity(context);
                }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ButtonPrimary(
                text: "Browse our ideas",
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
                text: "Change your location",
                secondary: true,
                padding: 0,
                active: true,
                onPressed: () {
                  Navigator.pushNamed(context, "/profile/location",
                      arguments: true);
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
                  context.loaderOverlay.show();
                  activities.promptPass().then(
                        (_) => context.loaderOverlay.hide(),
                      );
                }),
          ),
        ],
      ));
    });
  }
}
