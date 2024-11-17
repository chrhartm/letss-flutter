import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:letss_app/provider/userprovider.dart';

import '../widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpAge extends StatelessWidget {
  final bool signup;

  const SignUpAge({this.signup = true, super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "🎂",
        title: AppLocalizations.of(context)!.signupAgeTitle,
        subtitle: AppLocalizations.of(context)!.signupAgeSubtitle,
        back: true,
        child: AgeForm(
          signup: signup,
        ),
      ),
    );
  }
}

class AgeForm extends StatefulWidget {
  final bool signup;

  const AgeForm({required this.signup, super.key});

  @override
  AgeFormState createState() {
    return AgeFormState();
  }
}

class AgeFormState extends State<AgeForm> {
  int _ageState = 17;
  bool initialized = false;

  void updateAge(int age) {
    setState(() {
      _ageState = age;
      if (initialized == false) {
        initialized = true;
      }
    });
  }

  bool validate() {
    return _ageState >= 18;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (user.user.person.age > 18 && initialized == false) {
        // cannot call setstate from within build
        SchedulerBinding.instance.addPostFrameCallback((_) {
          updateAge(user.user.person.age);
        });
        // Preven scroll animation when updating age
        return Column(
          children: [],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: NumberPicker(
                    value: _ageState,
                    minValue: 0,
                    maxValue: 130,
                    haptics: false,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    selectedTextStyle: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            decoration: TextDecoration.underline),
                    onChanged: (value) => updateAge(value)),
              )),
          Flexible(
              child: ButtonPrimary(
                  onPressed: () {
                    if (validate()) {
                      user.updatePerson(age: _ageState);
                      Navigator.pushNamed(context,
                          widget.signup ? '/signup/job' : '/profile/job');
                    }
                  },
                  text: AppLocalizations.of(context)!.signupAgeNext,
                  active: validate())),
        ],
      );
    });
  }
}
