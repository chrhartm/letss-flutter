import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/myactivitiesprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditActivityDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubtitleHeaderScreen(
          top: "✍️",
          title: AppLocalizations.of(context)!.editActivityDescriptionTitle,
          subtitle: AppLocalizations.of(context)!.editActivityDescriptionTitle,
          child: DescriptionForm(),
          back: true,
        ),
      ),
    );
  }
}

class DescriptionForm extends StatefulWidget {
  const DescriptionForm({Key? key}) : super(key: key);

  @override
  DescriptionFormState createState() {
    return DescriptionFormState();
  }
}

class DescriptionFormState extends State<DescriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  bool valid = true;
  bool initialized = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  String? validateDescription(String? value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      if (textController.text == "" && !initialized) {
        textController.text = myActivities.editActivity.hasDescription
            ? myActivities.editActivity.description!
            : "";
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            valid = validateDescription(textController.text) == null;
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
                validator: validateDescription,
                textCapitalization: TextCapitalization.sentences,
                controller: textController,
                strutStyle: StrutStyle(forceStrutHeight: true),
                onChanged: (text) {
                  setState(() {
                    this.valid = validateDescription(text) == null;
                  });
                },
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 10,
                maxLength: 500,
                decoration: InputDecoration(
                    counterText: "",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          textController.clear();
                          valid = true;
                        });
                      },
                      icon: Icon(Icons.clear),
                      color: Theme.of(context).colorScheme.secondary,
                      focusColor: Theme.of(context).colorScheme.secondary,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15))),
            ButtonPrimary(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String description = textController.text.trim();
                  myActivities.updateActivity(description: description);
                  Navigator.pushNamed(
                      context, '/myactivities/activity/editcategories');
                }
              },
              text: AppLocalizations.of(context)!.editActivityDescriptionNext,
              active: valid,
            ),
          ],
        ),
      );
    });
  }
}
