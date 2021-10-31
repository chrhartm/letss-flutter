import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:provider/provider.dart';

import '../../backend/analyticsservice.dart';
import 'widgets/likedialog.dart';
import '../../models/activity.dart';
import 'widgets/activitycard.dart';
import 'widgets/nocards.dart';
import '../../provider/activitiesprovider.dart';
import '../widgets/buttons/buttonaction.dart';

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
  }) : super(key: key);

  List<Widget> _createCards(
      {required List<Activity> acts, required String status}) {
    List<Widget> cards = [];

    if (status == "EMPTY") {
      cards.add(Card(child: NoCards()));
    } else if (acts.length == 0) {
      cards.add(Card(child: Loader()));
    } else {
      for (int i = 0; i < acts.length; i++) {
        cards.add(ActivityCard(activity: acts[i]));
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<ActivitiesProvider>(
          builder: (context, activities, child) {
        Widget? fab;
        if (activities.activities.length > 0) {
          fab = Padding(
              padding: ButtonAction.buttonPadding,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
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
                        const SizedBox(height: ButtonAction.buttonGap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ButtonAction(
                              onPressed: () {
                                analytics.logEvent(name: "Activity_Pass");
                                activities.pass();
                              },
                              icon: Icons.not_interested,
                              hero: null,
                            ),
                            const SizedBox(width: ButtonAction.buttonGap),
                            ButtonAction(
                                onPressed: () {
                                  analytics.logEvent(name: "Activity_Like");
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return LikeDialog();
                                      });
                                },
                                icon: Icons.pan_tool,
                                hero: true,
                                coins: user.user.coins),
                          ],
                        )
                      ])));
        }

        return Scaffold(
            body: Stack(alignment: Alignment.bottomCenter, children: [
              Stack(
                alignment: Alignment.center,
                children: _createCards(
                    acts: activities.activities, status: activities.status),
              )
            ]),
            floatingActionButton: fab);
      });
    });
  }
}
