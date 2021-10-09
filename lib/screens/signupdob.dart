import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import 'signupjob.dart';
import '../provider/userprovider.dart';

class SignUpDob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'When were you born? 👶',
          subtitle: 'We will only show your age to others.',
          child: DobForm(),
          back: true,
        ),
      ),
    );
  }
}

class DobForm extends StatefulWidget {
  const DobForm({Key? key}) : super(key: key);

  @override
  DobFormState createState() {
    return DobFormState();
  }
}

class DobFormState extends State<DobForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputDatePickerFormField(
              // The validator receives the text that the user has entered.
              firstDate: DateTime(1900, 1, 1),
              lastDate: DateTime.now(),
              errorFormatText: "Wrong format",
              errorInvalidText: "Invalid date",
              initialDate: user.user.person.dob,
              onDateSubmitted: (date) {
                user.update(dob: date);
              },
            ),
            ButtonPrimary(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpJob()));
                },
                text: 'Next',
                active: user.user.person.age < 200),
          ],
        ),
      );
    });
  }
}
