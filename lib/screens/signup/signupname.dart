import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

class SignUpName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "🧑",
          title: 'What\'s your name?',
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
  bool valid = false;
  bool initialized = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    String val = value == null ? "" : value;
    String pattern = r"^[a-zA-Z0-9_ ]*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val) || val == "")
      return 'Enter a valid name';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "" && !initialized) {
        textController.text = user.user.person.name;
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
                maxLength: 40,
                decoration: InputDecoration(
                  counterText: "",
                )),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = textController.text.trim();
                  user.updatePerson(name: name);
                  Navigator.pushNamed(context, '/signup/gender');
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
