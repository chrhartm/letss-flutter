import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

class SignUpBio extends StatelessWidget {
  final bool signup;

  SignUpBio({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "✍️",
          title: 'Your bio',
          subtitle: 'Write a few sentences about yourself.',
          child: BioForm(signup: signup),
          back: true,
        ),
      ),
    );
  }
}

class BioForm extends StatefulWidget {
  final bool signup;

  const BioForm({required this.signup, Key? key}) : super(key: key);

  @override
  BioFormState createState() {
    return BioFormState();
  }
}

class BioFormState extends State<BioForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  bool valid = false;
  bool initialized = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateBio(String? value) {
    String val = value == null ? "" : value.trim();
    if (val == "")
      return 'Please write a few sentences';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "" && !initialized) {
        textController.text = user.user.person.bio;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            valid = validateBio(textController.text) == null;
            initialized = true;
          });
        });
      }
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
                child: TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: validateBio,
                    textCapitalization: TextCapitalization.sentences,
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    minLines: 3,
                    maxLength: 500,
                    strutStyle: StrutStyle(forceStrutHeight: true),
                    decoration: InputDecoration(
                      counterText: "",
                    ),
                    onChanged: (text) {
                      setState(() {
                        this.valid = validateBio(text) == null;
                      });
                    })),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String bio = textController.text.trim();
                  user.updatePerson(bio: bio);
                  if (widget.signup) {
                    Navigator.pushNamed(context, '/signup/pic');
                  } else {
                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                  }
                }
              },
              active: valid,
              text: widget.signup ? 'Next' : 'Save',
            ),
          ],
        ),
      );
    });
  }
}
