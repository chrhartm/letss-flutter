import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/widgets/likedialog.dart';
import 'package:provider/provider.dart';
import '../models/activity.dart';
import '../widgets/activitycard.dart';
import '../widgets/nocards.dart';
import '../provider/activitiesprovider.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
  }) : super(key: key);

  List<Widget> _createCards(List<Activity> acts) {
    List<Widget> cards = [];

    cards.add(Card(child: NoCards()));

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
                      FloatingActionButton(
                        onPressed: () {
                          analytics.logEvent(name: "Activity_Share");
                        },
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.grey,
                        heroTag: null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed: () {
                              analytics.logEvent(name: "Activity_Pass");
                              activities.pass();
                            },
                            child: Icon(
                              Icons.not_interested,
                              color: Colors.white,
                            ),
                            heroTag: null,
                            backgroundColor: Colors.grey,
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
              children: _createCards(activities.activities),
            )
          ]),
          floatingActionButton: fab);
    });
  }
}
