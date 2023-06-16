import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../backend/loggerservice.dart';
import '../../provider/navigationprovider.dart';
import '../../provider/userprovider.dart';
import '../widgets/other/loader.dart';
import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/myactivitiesprovider.dart';

class EditActivityName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        child: Scaffold(
          body: SafeArea(
            child: SubTitleHeaderScreen(
              top: "💡",
              title: 'What do you want to do?',
              subtitle: "Keep it short - this is a headline",
              child: NameForm(),
              back: true,
            ),
          ),
        ));
  }
}

class NameForm extends StatefulWidget {
  const NameForm({Key? key}) : super(key: key);

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
    if (val == "")
      return 'Write a few words';
    else
      return null;
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
                    this.valid = validateName(text) == null;
                  });
                },
                maxLength: 50,
                decoration: InputDecoration(
                    counterText: "",
                    hintText: "Let's ...",
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
                    String idea = myActivities.getIdea();
                    textController.text = idea;
                    this.valid = validateName(idea) == null;
                  });
                },
                active: true,
                text: 'Get an idea',
                secondary: valid,
              ),
              ButtonPrimary(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String name = textController.text.trim();
                      myActivities
                          .updateActivity(name: name)
                          // Need to await because otherwise no activit id and
                          // likestream will fail
                          .then((activity) {
                        UserProvider user =
                            Provider.of<UserProvider>(context, listen: false);
                        if (!user.user.finishedSignupFlow) {
                          user.user.finishedSignupFlow = true;
                          user.forceNotify();
                          Provider.of<NavigationProvider>(context,
                                  listen: false)
                              .navigateTo("/myactivities");
                          Navigator.popUntil(
                              context, (Route<dynamic> route) => route.isFirst);
                        } else {
                          Navigator.pushNamed(context,
                              '/myactivities/activity/editdescription');
                        }
                      }).catchError((error) {
                        LoggerService.log(
                            'Couldn\'t to update idea' + error.toString(),
                            level: "e");
                      });
                    }
                  },
                  active: valid,
                  text: user.user.finishedSignupFlow ? 'Next' : "Finish",
                  padding: 0),
            ],
          ),
        );
      });
    });
  }
}
