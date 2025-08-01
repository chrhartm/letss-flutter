import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/myactivities/widgets/removeparticipantdialog.dart';
import 'package:letss_app/screens/widgets/buttons/circlebutton.dart';
import 'package:letss_app/screens/widgets/other/BasicListTile.dart';
import 'package:provider/provider.dart';
import '../../../../models/activity.dart';
import '../../../../models/person.dart';
import '../../../../provider/myactivitiesprovider.dart';

class ParticipantPreview extends StatelessWidget {
  const ParticipantPreview(
      {super.key,
      required this.person,
      required this.activity,
      this.removable = false});

  final Person person;
  final Activity activity;
  final bool removable;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, activities, child) {
      return BasicListTile(
        noPadding: true,
        onTap: kIsWeb
            ? null
            : () {
                Navigator.pushNamed(context, '/profile/person',
                    arguments: person);
              },
        leading: person.thumbnail,
        title: person.name,
        subtitle: person.job,
        trailing: removable
            ? CircleButton(
                icon: Icons.remove,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return RemoveParticipantDialog(
                            participant: person, activity: activity);
                      });
                },
                highlighted: false)
            : null,
      );
    });
  }
}
