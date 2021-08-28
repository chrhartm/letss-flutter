import 'package:flutter/material.dart';
import 'package:letss_app/provider/likesprovider.dart';
import 'editactivitydescription.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/button1.dart';

class EditActivityName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'What\'s the activity? 🤹',
          subtitle: 'Formulate it as a suggestion',
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
    return Consumer<LikesProvider>(builder: (context, likes, child) {
      if (textController.text == "") {
        textController.text = likes.editActivity.name;
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
            ),
            Button1(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = textController.text;
                  likes.updateActivity(name: name);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditActivityDescription()));
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
