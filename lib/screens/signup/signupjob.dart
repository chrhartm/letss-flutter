import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

class SignUpJob extends StatelessWidget {
  final bool signup;

  SignUpJob({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "‍🤔",
          title: 'What do you do?',
          subtitle: 'Your job, studies, ...',
          child: JobForm(signup: signup,),
          back: true,
        ),
      ),
    );
  }
}

class JobForm extends StatefulWidget {
  final bool signup;

  const JobForm({required this.signup, Key? key}) : super(key: key);

  @override
  JobFormState createState() {
    return JobFormState();
  }
}

class JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  bool valid = false;
  bool initialized = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateJob(String? value) {
    String val = value == null ? "" : value;
    if (val == "")
      return 'Enter a valid job';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "" && !initialized) {
        textController.text = user.user.person.job;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            valid = validateJob(textController.text) == null;
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
              validator: validateJob,
              textCapitalization: TextCapitalization.sentences,
              controller: textController,
              onChanged: (text) {
                setState(() {
                  this.valid = validateJob(text) == null;
                });
              },
              maxLength: 50,
              decoration: InputDecoration(
                  counterText: "", hintText: "Monkey at National Park"),
            ),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String job = textController.text.trim();
                  user.updatePerson(job: job);
                  Navigator.pushNamed(context, widget.signup?'/signup/location':'/profile/location');
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
