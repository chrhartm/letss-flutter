import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../../backend/loggerservice.dart';
import '../../provider/userprovider.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/myactivitiesprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditActivityName extends StatelessWidget {
  const EditActivityName({super.key});
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "💡",
        title: AppLocalizations.of(context)!.editActivityNameTitle(
            Provider.of<UserProvider>(context, listen: false)
                .user
                .person
                .shortLocationString),
        subtitle: AppLocalizations.of(context)!.editActivityNameSubtitle,
        back: true,
        child: NameForm(),
      ),
    );
  }
}

class NameForm extends StatefulWidget {
  const NameForm({super.key});

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
    if (val == "") {
      return AppLocalizations.of(context)!.editActivityNameEmptyHint;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<MyActivitiesProvider>(
          builder: (context, myActivities, child) {
        if (textController.text == "" && !initialized) {
          textController.text = myActivities.editActivity.name;
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
                maxLength: 50,
                decoration: InputDecoration(
                    counterText: "",
                    hintText:
                        AppLocalizations.of(context)!.editActivityNameDefault,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          textController.clear();
                          valid = false;
                        });
                      },
                      icon: Icon(Icons.clear),
                      color: Theme.of(context).colorScheme.secondary,
                      focusColor: Theme.of(context).colorScheme.secondary,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15)),
              ),
              ButtonPrimary(
                onPressed: () {
                  setState(() {
                    String idea =
                        myActivities.getIdea(Localizations.localeOf(context));
                    textController.text = idea;
                    valid = validateName(idea) == null;
                  });
                },
                active: true,
                text: AppLocalizations.of(context)!.editActivityNameGetIdea,
                secondary: valid,
              ),
              Flexible(
                child: ButtonPrimary(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String name = textController.text.trim();
                        myActivities
                            .updateActivity(name: name)
                            .then((activity) {
                          if (context.mounted) {
                            UserProvider user = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            if (context.mounted) {
                              if (!user.user.finishedSignupFlow) {
                                Navigator.pushNamed(context,
                                    '/myactivities/activity/editcategories');
                              } else {
                                Navigator.pushNamed(context,
                                    '/myactivities/activity/editdescription');
                              }
                            }
                          }
                        }).catchError((error) {
                          LoggerService.log('Couldn\'t to update idea',
                              level: "w");
                        });
                      }
                    },
                    active: valid,
                    text: user.user.finishedSignupFlow
                        ? AppLocalizations.of(context)!.editActivityNameNext
                        : AppLocalizations.of(context)!.editActivityNameFinish,
                    padding: 0),
              )
            ],
          ),
        );
      });
    });
  }
}
