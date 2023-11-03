import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpBio extends StatelessWidget {
  final bool signup;

  SignUpBio({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "✍️",
        title: AppLocalizations.of(context)!.signupBioTitle,
        subtitle: AppLocalizations.of(context)!.signupBioSubtitle,
        child: BioForm(signup: signup),
        back: true,
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
    String? val = value == null ? "" : value.trim();
    if (val.length > 500)
      return AppLocalizations.of(context)!.signupBioTooLong;
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (textController.text == "" && !initialized) {
        textController.text =
            user.user.person.hasBio ? user.user.person.bio! : "";
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
          children: [TextFormField(
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
                    }),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String bio = textController.text.trim();
                  user.updatePerson(bio: bio);
                  if (widget.signup) {
                    Navigator.pushNamed(context, '/signup/interests');
                  } else {
                    if (user.user.person.hasInterests) {
                      Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                    } else {
                      Navigator.pushNamed(context, '/profile/interests');
                    }
                  }
                }
              },
              active: valid,
              text: widget.signup
                  ? AppLocalizations.of(context)!.signupBioNextSignup
                  : (user.user.person.hasInterests
                      ? AppLocalizations.of(context)!.signupBioNextProfileFinish
                      : AppLocalizations.of(context)!.signupBioNextProfileNext),
            ),
          ],
        ),
      );
    });
  }
}
