import 'package:flutter/material.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/activitypreview.dart';

import 'tile.dart';
import 'package:letss_app/models/person.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivitiesTile extends StatelessWidget {
  const ActivitiesTile({super.key, required this.person});

  final Person person;

  Widget _buildActivity({required Activity activity}) {
    return ActivityPreview(activity: activity);
  }

  @override
  Widget build(BuildContext context) {
    return Tile(
        child: StreamBuilder(
            stream: ActivityService.streamActivities(person: person),
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<Activity>> activities) {
              if (activities.hasData && activities.data!.isNotEmpty) {
                return Column(children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocalizations.of(context)!.activities,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.titleLarge)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) =>
                        _buildActivity(
                            activity: activities.data!.elementAt(index)),
                    itemCount: activities.data!.length,
                    reverse: true,
                  )
                ]);
              } else if (activities.connectionState ==
                  ConnectionState.waiting) {
                return const SizedBox(height: 0);
              } else {
                return const SizedBox(height: 0);
              }
            }));
  }
}
