import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/buttons/buttonselection.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';

class SignUpGender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: '⚧️',
          title: 'How do you identify?',
          subtitle: 'For people who want to filter by gender.',
          child: GenderForm(
              initialGender: Provider.of<UserProvider>(context, listen: false)
                  .user
                  .person
                  .gender),
          back: true,
        ),
      ),
    );
  }
}

class GenderForm extends StatefulWidget {
  const GenderForm({required this.initialGender, Key? key}) : super(key: key);

  final String initialGender;

  @override
  GenderFormState createState() {
    return GenderFormState();
  }
}

class GenderFormState extends State<GenderForm> {
  String? _gender = null;

  @override
  void initState() {
    _gender = widget.initialGender;
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
                        text: "Male",
                        onPressed: () {
                          setState(() {
                            this._gender = "male";
                          });
                        },
                        selected: this._gender == "male"),
                    ButtonSelection(
                        text: "Female",
                        onPressed: () {
                          setState(() {
                            this._gender = "female";
                          });
                        },
                        selected: this._gender == "female"),
                    ButtonSelection(
                        text: "Diverse",
                        onPressed: () {
                          setState(() {
                            this._gender = "";
                          });
                        },
                        selected: this._gender == ""),
                  ])),
          ButtonPrimary(
            onPressed: () {
              user.update(gender: _gender);
              Navigator.pushNamed(context, '/signup/dob');
            },
            text: 'Next',
          ),
        ],
      );
    });
  }
}
