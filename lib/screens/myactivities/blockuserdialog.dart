import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/dialogs/mydialog.dart';
import '../../models/person.dart';
import '../../provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BlockUserDialog extends StatelessWidget {
  const BlockUserDialog({Key? key, required this.blocked}) : super(key: key);

  final Person blocked;

  void block(BuildContext context) {
    UserProvider.blockUser(blocked);
  }

  @override
  Widget build(BuildContext context) {
    return MyDialog(
      title: AppLocalizations.of(context)!.blockUserDialogTitle(blocked.name),
      content: MyDialog.textContent(
        AppLocalizations.of(context)!.blockUserDialogMessage(blocked.name),
      ),
      action: () {
        block(context);
        NavigatorState nav = Navigator.of(context);
        nav.pop();
        nav.pop();
      },
      actionLabel: AppLocalizations.of(context)!.blockUserDialogAction,
    );
  }
}
