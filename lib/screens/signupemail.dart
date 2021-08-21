import 'package:flutter/material.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/button1.dart';
import '../backend/auth.dart';

class SignUpEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'Welcome 👋',
          subtitle: 'What\'s your email?',
          child: EmailForm(),
          back: true,
        ),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  EmailFormState createState() {
    return EmailFormState();
  }
}

class EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    String val = value == null ? "" : value;
    // TODO do better job, doesn't catch asdf@asdf
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val) || val == "")
      return 'Enter a valid email address';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: validateEmail,
            controller: textController,
          ),
          Button1(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Auth.emailAuth(textController.text);
              }
            },
            text: 'Next',
          ),
        ],
      ),
    );
  }
}
