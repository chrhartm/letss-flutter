import 'package:flutter/material.dart';
import 'signupdob.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import '../provider/userprovider.dart';

class SignUpName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'What\'s your name? 🧑',
          subtitle: 'Nice to meet you!',
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
      return 'Enter a valid name';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "") {
        textController.text = user.user.person.name;
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
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = textController.text;
                  user.update(name: name);
                  Navigator.pushNamed(context, '/signup/dob');
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
