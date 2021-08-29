import 'package:flutter/material.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

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
                  child: Text('Back', style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                TextButton(
                  child: Text('Send', style: TextStyle(color: Colors.orange)),
                  onPressed: () {
                    setState(() {
                      activities.like(valueText);
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: Icon(
          Icons.pan_tool,
          color: Colors.white,
        ));
  }
}
