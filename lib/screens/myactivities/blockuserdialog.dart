import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import '../../models/person.dart';
import '../../provider/userprovider.dart';

class BlockUserDialog extends StatelessWidget {
  const BlockUserDialog({Key? key, required this.blocked}) : super(key: key);

  final Person blocked;

  void block(BuildContext context) {
    UserProvider.blockUser(blocked);
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: 'Do you want to block ${blocked.name}? ',
      content: MyDialog.textContent(
        'You will no longer receive any messages or likes from ${blocked.name}.',
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
