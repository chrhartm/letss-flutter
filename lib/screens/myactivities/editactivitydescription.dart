import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons/buttonprimary.dart';
import '../../provider/myactivitiesprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditActivityDescription extends StatelessWidget {
  const EditActivityDescription({super.key});
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "✍️",
        title: AppLocalizations.of(context)!.editActivityDescriptionTitle,
        subtitle: AppLocalizations.of(context)!.editActivityDescriptionSubtitle,
        back: true,
        child: DescriptionForm(),
      ),
    );
  }
}

class DescriptionForm extends StatefulWidget {
  const DescriptionForm({super.key});

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
                    valid = validateDescription(text) == null;
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
            Flexible(
                child: ButtonPrimary(
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
            )),
          ],
        ),
      );
    });
  }
}
