import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpName extends StatelessWidget {
  final bool signup;

  const SignUpName({this.signup = true, super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "🧑",
        title: AppLocalizations.of(context)!.signupNameTitle,
        subtitle: AppLocalizations.of(context)!.signupNameSubtitle,
        back: true,
        child: NameForm(signup: signup),
      ),
    );
  }
}

class NameForm extends StatefulWidget {
  final bool signup;
  const NameForm({required this.signup, super.key});

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
    String val = value == null ? "" : value.trim();
    String pattern = r"^[a-zA-Z0-9_ ]*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(val) || val == "") {
      return AppLocalizations.of(context)!.signupNameValidatorError;
    } else {
      return null;
    }
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
                    valid = validateName(text) == null;
                  });
                },
                maxLength: 40,
                decoration: InputDecoration(
                  counterText: "",
                )),
            Flexible(
                child: ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String name = textController.text.trim();
                  user.updatePerson(name: name);
                  Navigator.pushNamed(
                      context, widget.signup ? '/signup/age' : '/profile/age');
                }
              },
              active: valid,
              text: widget.signup
                  ? AppLocalizations.of(context)!.signupNameNextSignup
                  : AppLocalizations.of(context)!.signupNameNextProfile,
            )),
          ],
        ),
      );
    });
  }
}
