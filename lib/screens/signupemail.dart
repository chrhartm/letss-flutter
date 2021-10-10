import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import '../backend/authservice.dart';
import '../provider/userprovider.dart';
import 'signupwaitlink.dart';

class SignUpEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'Welcome 👋',
          subtitle: 'What\'s your email?',
          child: EmailForm(),
          back: false,
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
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: validateEmail,
              controller: textController,
              initialValue: user.user.email,
            ),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String email = textController.text;
                  user.user.email = email;
                  AuthService.emailAuth(email);
                  Navigator.pushNamed(context, '/signup/waitlink');
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
