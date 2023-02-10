import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/flagdialog.dart';

class FlagTile extends StatelessWidget {
  const FlagTile(
      {Key? key, required this.flagger, required this.flagged, this.activity})
      : super(key: key);
  final Person flagger;
  final Person flagged;
  final Activity? activity;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20), child: Divider()),
          Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return FlagDialog(
                              flagged: flagged,
                              flagger: flagger,
                              activity: activity);
                        });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag),
                      const SizedBox(width: 10),
                      Text("Report")
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide()))))
        ]);
  }
}
