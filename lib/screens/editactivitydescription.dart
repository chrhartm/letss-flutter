import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import 'editactivitycategories.dart';

class EditActivityDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'Give us more details ✍️',
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
    return Consumer<MyActivitiesProvider>(builder: (context, myActivities, child) {
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
                controller: textController,
                keyboardType: TextInputType.multiline,
                maxLines: null),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String description = textController.text;
                  myActivities.updateActivity(description: description);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditActivityCategories()));
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
