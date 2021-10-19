import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/analyticsservice.dart';
import '../widgets/likedialog.dart';
import '../models/activity.dart';
import '../widgets/activitycard.dart';
import '../widgets/nocards.dart';
import '../provider/activitiesprovider.dart';
import '../widgets/buttonaction.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
  }) : super(key: key);

  List<Widget> _createCards(
      {required List<Activity> acts, bool withEmptyCard = false}) {
    List<Widget> cards = [];

    if (withEmptyCard) {
      cards.add(Card(child: NoCards()));
    }

    for (int i = 0; i < acts.length; i++) {
      cards.add(ActivityCard(activity: acts[i]));
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivitiesProvider>(builder: (context, activities, child) {
      Widget? fab;
      if (activities.activities.length > 0) {
        fab = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonAction(
                        onPressed: () {
                          analytics.logEvent(name: "Activity_Share");
                          activities.share();
                        },
                        icon: Icons.share,
                        hero: null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ButtonAction(
                            onPressed: () {
                              analytics.logEvent(name: "Activity_Pass");
                              activities.pass();
                            },
                            icon: Icons.not_interested,
                            hero: null,
                          ),
                          const SizedBox(width: 8),
                          LikeButton()
                        ],
                      )
                    ])));
      }

      return Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
            Stack(
              alignment: Alignment.center,
              children: _createCards(
                  acts: activities.activities,
                  withEmptyCard: activities.status == "EMPTY"),
            )
          ]),
          floatingActionButton: fab);
    });
  }
}
