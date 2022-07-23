import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/myactivitiesprovider.dart';

class EditActivityName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "🤹",
          title: 'What do you want to do?',
          subtitle: "Keep it short - this is a headline",
          child: NameForm(),
          back: true,
        ),
      ),
    );
  }
}

class NameForm extends StatefulWidget {
  const NameForm({Key? key}) : super(key: key);

  @override
  NameFormState createState() {
    return NameFormState();
  }
}

class NameFormState extends State<NameForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  bool valid = false;
  bool initialized = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    String val = value == null ? "" : value;
    if (val == "")
      return 'Enter a valid activity name';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      if (textController.text == "" && !initialized) {
        textController.text = myActivities.editActivity.name;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            valid = validateName(textController.text) == null;
            initialized = true;
          });
        });
      }
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: validateName,
              textCapitalization: TextCapitalization.sentences,
              controller: textController,
              onChanged: (text) {
                setState(() {
                  this.valid = validateName(text) == null;
                });
              },
              maxLength: 50,
              decoration: InputDecoration(
                  counterText: "",
                  hintText: "Let's climb a tree and eat bananas",
                  suffixIcon: IconButton(
                    onPressed: textController.clear,
                    icon: Icon(Icons.clear),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15)),
            ),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = textController.text.trim();
                  myActivities.updateActivity(name: name);
                  Navigator.pushNamed(
                      context, '/myactivities/activity/editdescription');
                }
              },
              active: valid,
              text: 'Next',
            ),
          ],
        ),
      );
    });
  }
}
