import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/flag.dart';

import 'package:letss_app/models/person.dart';
import 'package:letss_app/backend/flagservice.dart';

class FlagTile extends StatefulWidget {
  const FlagTile(
      {Key? key, required this.flagger, required this.flagged, this.activity})
      : super(key: key);
  final Person flagger;
  final Person flagged;
  final Activity? activity;
  @override
  FlagTileState createState() {
    return FlagTileState();
  }
}

class FlagTileState extends State<FlagTile> {
  final _textFieldController = TextEditingController();

  String message = "";

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Why do you want to report this?',
                style: Theme.of(context).textTheme.headline4),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
              controller: _textFieldController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(hintText: ""),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Back',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Report',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryVariant)),
                onPressed: () {
                  Flag flag = Flag(
                      flagger: widget.flagger,
                      flagged: widget.flagged,
                      activity: widget.activity,
                      message: message);
                  if (message.length > 0) {
                    analytics.logEvent(name: "Flag_Message");
                    FlagService.flag(flag);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Thank you for reporting this.")));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

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
                    analytics.logEvent(name: "Flag");
                    _displayTextInputDialog(context);
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
                      primary: Theme.of(context).colorScheme.secondary,
                      textStyle: Theme.of(context).textTheme.headline4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide()))))
        ]);
  }
}
