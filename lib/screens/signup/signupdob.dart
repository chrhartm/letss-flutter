import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/mytextbutton.dart';

class SignUpDob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "👶",
          title: 'When were you born?',
          subtitle: "We'll show your age on your profile.",
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
  static const String initialText = "Tap to select a date";

  DateTime _dateState = DateTime.parse("2000-01-01");
  bool initialized = false;
  TextEditingController _dateController = TextEditingController();
  DateTime olderThan18 = DateTime(
      DateTime.now().year - 18, DateTime.now().month, DateTime.now().day);

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateState,
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(1900, 1, 1),
      lastDate: olderThan18,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              textButtonTheme:TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondaryVariant),),)
            child: child!);
      },
    );
    if (picked != null) updateDate(picked);
  }

  void updateDate(DateTime date) {
    setState(() {
      _dateState = date;
      _dateController.text = DateFormat("yyyy-MM-dd").format(_dateState);
      if (initialized == false) {
        initialized = true;
      }
    });
  }

  bool validate(){
    return _dateController.text != initialText;
  }

  @override
  void initState() {
    _dateController.text = initialText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (user.user.person.age > 18 && initialized == false) {
        // cannot call setstate from within build
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          updateDate(user.user.person.dob);
        });
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: MyTextButton(
                      text: _dateController.text,
                      onPressed: () => _selectDate(context),
                      ))),
          ButtonPrimary(
              onPressed: () {
                if (validate()) {
                  user.update(dob: _dateState);
                  Navigator.pushNamed(context, '/signup/job');
                }
              },
              text: 'Next',
              active:
                  validate()),
        ],
      );
    });
  }
}
