import 'package:flutter/material.dart';
import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/myactivities/blockuserdialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlockTile extends StatelessWidget {
  const BlockTile({super.key, required this.blocked});
  final Person blocked;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return BlockUserDialog(
                          blocked: blocked,
                        );
                      });
                },
                style: OutlinedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide())),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.block),
                    const SizedBox(width: 10),
                    Text(AppLocalizations.of(context)!.block)
                  ],
                ),
              ))
        ]);
  }
}
