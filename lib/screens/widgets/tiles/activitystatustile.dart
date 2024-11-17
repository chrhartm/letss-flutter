import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AcitivityStatusTile extends StatelessWidget {
  const AcitivityStatusTile({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    String text = AppLocalizations.of(context)!.activityStatusArchived;
    if (activity.isArchived) {
      // Return a shaded info box with rounded corners that states that the activity is archived
      return Tile(
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(text,
                      style: Theme.of(context).textTheme.bodyLarge))));
    }
    return Container();
  }
}
