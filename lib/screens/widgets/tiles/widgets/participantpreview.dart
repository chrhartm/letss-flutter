import 'package:flutter/material.dart';
import 'package:letss_app/screens/chats/profile.dart';
import '../../../../models/person.dart';

class ParticipantPreview extends StatelessWidget {
  const ParticipantPreview({Key? key,  required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(
                      person: person)
                    ));
      },
      contentPadding: EdgeInsets.zero,
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
    );
  }
}
