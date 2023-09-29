import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/participantpreview.dart';
import 'tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParticipantsTile extends StatelessWidget {
  const ParticipantsTile({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  Widget _buildParticipant(
      {required Person participant, required Activity activity}) {
    return ParticipantPreview(person: participant, activity: activity);
  }

  @override
  Widget build(BuildContext context) {
    if (activity.hasParticipants) {
      return Tile(
          child: Column(children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(AppLocalizations.of(context)!.participantsJoining,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge)),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) => _buildParticipant(
              participant: activity.participants.elementAt(index),
              activity: activity),
          itemCount: activity.participants.length,
          reverse: false,
        )
      ]));
    } else {
      return Container();
    }
  }
}
