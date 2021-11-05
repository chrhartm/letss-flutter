import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

class SignUpJob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "‍🤔",
          title: 'What do you do? ',
          subtitle: 'Your job, studies, ...',
          child: JobForm(),
          back: true,
        ),
      ),
    );
  }
}

class JobForm extends StatefulWidget {
  const JobForm({Key? key}) : super(key: key);

  @override
  JobFormState createState() {
    return JobFormState();
  }
}

class JobFormState extends State<JobForm> {
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
      return 'Enter a valid job';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "") {
        textController.text = user.user.person.job;
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
                  String job = textController.text;
                  user.update(job: job);
                  Navigator.pushNamed(context, '/signup/bio');
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
