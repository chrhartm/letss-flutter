import 'package:flutter/material.dart';
import 'package:letss_app/screens/myactivities/widgets/leavechatdialog.dart';
import 'package:provider/provider.dart';
import '../../../../models/activity.dart';
import '../../../../models/person.dart';
import '../../../../provider/myactivitiesprovider.dart';

class ParticipantPreview extends StatelessWidget {
  const ParticipantPreview(
      {Key? key, required this.person, required this.activity})
      : super(key: key);

  final Person person;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, activities, child) {
      bool isOwner = activities.isOwner(activity: activity);
      return ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/profile/person', arguments: person);
        },
        contentPadding: EdgeInsets.zero,
        leading: person.thumbnail,
        title: Text(person.name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        subtitle: Text(person.job,
            style: Theme.of(context).textTheme.bodyMedium!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        trailing: isOwner
            ? IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return RemoveParticipantDialog(
                            participant: person, activity: activity);
                      });
                },
              )
            : null,
      );
    });
  }
}
