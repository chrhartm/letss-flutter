import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons/buttonprimary.dart';
import '../../backend/authservice.dart';
import '../../provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpEmail extends StatelessWidget {

  void setAppLocale(BuildContext context) {
    final Locale appLocale = Localizations.localeOf(context);
    FirebaseAuth.instance.setLanguageCode(appLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {

    setAppLocale(context);

    return MyScaffold(
      body: HeaderScreen(
        top: "👋",
        title: AppLocalizations.of(context)!.signupEmailTitle,
        subtitle: AppLocalizations.of(context)!.signupEmailSubtitle,
        child: EmailForm(),
        back: true,
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
    String val = value == null ? "" : value.trim();
    String pattern =
        r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(val) || val == "")
      return AppLocalizations.of(context)!.signupEmailInvalid;
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
              textCapitalization: TextCapitalization.none,
              controller: textController,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.signupEmailHint),
              initialValue: null,
            ),
            Flexible(child: ButtonPrimary(
              onPressed: () {
                if (textController.text.contains(':')) {
                  List<String> segments = textController.text.split(':');

                  String password = segments[1];
                  String email = segments[0];
                  user.user.email = email;
                  AuthService.emailPasswordAuth(
                      email: email, password: password);
                } else if (_formKey.currentState!.validate()) {
                  String email = textController.text.trim();
                  user.user.email = email;
                  AuthService.emailAuth(email);
                  Navigator.pushNamed(context, '/signup/waitlink');
                }
              },
              text: AppLocalizations.of(context)!.signupEmailNext,
            )),
          ],
        ),
      );
    });
  }
}
