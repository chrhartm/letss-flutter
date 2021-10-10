import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import '../provider/userprovider.dart';

class SignUpBio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'Your bio ✍️',
          subtitle: 'What\'s unique about you?',
          child: BioForm(),
          back: true,
        ),
      ),
    );
  }
}

class BioForm extends StatefulWidget {
  const BioForm({Key? key}) : super(key: key);

  @override
  BioFormState createState() {
    return BioFormState();
  }
}

class BioFormState extends State<BioForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateBio(String? value) {
    String val = value == null ? "" : value;
    if (val == "")
      return 'Please write a few sentences';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "") {
        textController.text = user.user.person.bio;
      }
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
                // The validator receives the text that the user has entered.
                validator: validateBio,
                controller: textController,
                keyboardType: TextInputType.multiline,
                maxLines: null),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String bio = textController.text;
                  user.update(bio: bio);
                  Navigator.pushNamed(context, '/signup/location');
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
