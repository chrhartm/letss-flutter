import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/buttons/buttonselection.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpGender extends StatelessWidget {
  final bool signup;

  SignUpGender({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubtitleHeaderScreen(
          top: '⚧️',
          title: AppLocalizations.of(context)!.signupGenderTitle,
          subtitle: AppLocalizations.of(context)!.signupGenderSubtitle,
          child: GenderForm(
              initialGender: Provider.of<UserProvider>(context, listen: false)
                  .user
                  .person
                  .gender,
              signup: signup),
          back: true,
        ),
      ),
    );
  }
}

class GenderForm extends StatefulWidget {
  final bool signup;

  const GenderForm(
      {required this.initialGender, required this.signup, Key? key})
      : super(key: key);

  final String? initialGender;

  @override
  GenderFormState createState() {
    return GenderFormState();
  }
}

class GenderFormState extends State<GenderForm> {
  String _gender = "";

  @override
  void initState() {
    _gender = widget.initialGender == null ? "" : widget.initialGender!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Column(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonSelection(
                        text: AppLocalizations.of(context)!.signupGenderMale,
                        onPressed: () {
                          setState(() {
                            this._gender = "male";
                          });
                        },
                        selected: this._gender == "male"),
                    ButtonSelection(
                        text: AppLocalizations.of(context)!.signupGenderFemale,
                        onPressed: () {
                          setState(() {
                            this._gender = "female";
                          });
                        },
                        selected: this._gender == "female"),
                    ButtonSelection(
                        text: AppLocalizations.of(context)!.signupGenderOther,
                        onPressed: () {
                          setState(() {
                            this._gender = "";
                          });
                        },
                        selected: this._gender == ""),
                  ])),
          ButtonPrimary(
            onPressed: () {
              user.updatePerson(gender: _gender);
              Navigator.pushNamed(
                  context, widget.signup ? '/signup/age' : '/profile/age');
            },
            text: AppLocalizations.of(context)!.signupGenderNext,
          ),
        ],
      );
    });
  }
}
