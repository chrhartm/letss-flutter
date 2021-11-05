import 'package:flutter/material.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
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
          subtitle: 'Keep it short - this is a headline.',
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
      if (textController.text == "") {
        textController.text = myActivities.editActivity.name;
      }
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                // The validator receives the text that the user has entered.
                validator: validateName,
                controller: textController,
                decoration: InputDecoration(hintText: "Let's ...")),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = textController.text;
                  myActivities.updateActivity(name: name);
                  Navigator.pushNamed(
                      context, '/myactivities/activity/editdescription');
                }
              },
              text: 'Next',
            ),
          ],
        ),
      );
    });
  }
}
