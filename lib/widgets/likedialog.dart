import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../backend/analyticsservice.dart';
import '../provider/activitiesprovider.dart';
import 'buttonaction.dart';
import '../provider/userprovider.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({Key? key}) : super(key: key);

  @override
  LikeButtonState createState() {
    return LikeButtonState();
  }
}

class LikeButtonState extends State<LikeButton> {
  final _textFieldController = TextEditingController();

  String codeDialog = "";
  String valueText = "";

  String? validateName(String? value) {
    String val = value == null ? "" : value;
    if (val == "")
      return 'Enter a message';
    else
      return null;
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Consumer<ActivitiesProvider>(
              builder: (context, activities, child) {
            return AlertDialog(
              title: Text('Why are you excited about this? 🥳',
                  style: Theme.of(context).textTheme.headline4),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    valueText = value;
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
                  child: Text('Send',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.secondaryVariant)),
                  onPressed: () {
                    analytics.logEvent(name: "Activity_Message");
                    activities.like(valueText);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return ButtonAction(
          onPressed: () {
            analytics.logEvent(name: "Activity_Like");
            _displayTextInputDialog(context);
          },
          icon: Icons.pan_tool,
          hero: true,
          coins: user.user.coins);
    });
  }
}
