import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import 'package:provider/provider.dart';

import '../../backend/userservice.dart';
import '../../models/like.dart';

class BlockUserDialog extends StatelessWidget {
  const BlockUserDialog({Key? key, required this.like}) : super(key: key);

  final Like like;

  void block(BuildContext context) {
    Provider.of<MyActivitiesProvider>(context, listen: false)
        .passLike(like: like);
    UserService.blockUser(like.person.uid);
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Do you want to block ${like.person.name}? ',
      content: MyDialog.TextContent(
        'You will no longer receive any messages or likes from ${like.person.name}.',
      ),
      action: () {
        block(context);
        NavigatorState nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
      actionLabel: 'Yes',
    );
  }
}
