import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpJob extends StatelessWidget {
  final bool signup;

  SignUpJob({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "‍🤔",
        title: AppLocalizations.of(context)!.signupJobTitle,
        subtitle: AppLocalizations.of(context)!.signupJobSubtitle,
        child: JobForm(
          signup: signup,
        ),
        back: true,
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
    String val = value == null ? "" : value.trim();
    if (val == "")
      return AppLocalizations.of(context)!.signupJobEmpty;
    else if (val.length > 50)
      return AppLocalizations.of(context)!.signupJobLong;
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
                  counterText: "",
                  hintText: AppLocalizations.of(context)!.signupJobHint),
            ),
            Flexible(child: ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String job = textController.text.trim();
                  user.updatePerson(job: job);
                  Navigator.pushNamed(context,
                      // need location before interests because interests are
                      // based on location
                      widget.signup ? '/signup/location' : '/profile/location');
                }
              },
              active: valid,
              text: widget.signup
                  ? AppLocalizations.of(context)!.signupJobNextSignup
                  : AppLocalizations.of(context)!.signupJobNextProfile,
            )),
          ],
        ),
      );
    });
  }
}
