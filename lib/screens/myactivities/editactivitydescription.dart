import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/myactivitiesprovider.dart';

class EditActivityDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "✍️",
          title: 'Give us more details',
          subtitle: 'What will you be doing?',
          child: DescriptionForm(),
          back: true,
        ),
      ),
    );
  }
}

class DescriptionForm extends StatefulWidget {
  const DescriptionForm({Key? key}) : super(key: key);

  @override
  DescriptionFormState createState() {
    return DescriptionFormState();
  }
}

class DescriptionFormState extends State<DescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateDescription(String? value) {
    String val = value == null ? "" : value;
    if (val == "")
      return 'Please write a few sentences';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      if (textController.text == "") {
        textController.text = myActivities.editActivity.description;
      }
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                // The validator receives the text that the user has entered.
                validator: validateDescription,
                textCapitalization: TextCapitalization.sentences,
                controller: textController,
                keyboardType: TextInputType.multiline,
                maxLines: null),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String description = textController.text;
                  myActivities.updateActivity(description: description);
                  Navigator.pushNamed(
                      context, '/myactivities/activity/editcategories');
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
