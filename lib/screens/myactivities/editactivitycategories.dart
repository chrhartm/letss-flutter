import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:provider/provider.dart';

import '../../backend/analyticsservice.dart';
import '../../models/category.dart';
import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../backend/activityservice.dart';
import '../../provider/myactivitiesprovider.dart';
import '../../provider/userprovider.dart';

class EditActivityCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "🏷️",
          title: 'Which interests fit this activity?',
          subtitle:
              'We will show your activity to people with these interests.',
          child: TagSelector(),
          back: true,
        ),
      ),
    );
  }
}

class TagSelector extends StatefulWidget {
  const TagSelector({Key? key}) : super(key: key);

  @override
  TagSelectorState createState() {
    return TagSelectorState();
  }
}

class TagSelectorState extends State<TagSelector> {
  List<Category> _selectedCategories = [];
  bool init = false;
  int maxitems = 10;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myActivities, child) {
      if (!init) {
        init = true;
        _selectedCategories = List.from(myActivities.editActivity.categories);
      }
      return Consumer<UserProvider>(builder: (context, user, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlutterTagging<Category>(
                initialItems: _selectedCategories,
                hideOnError: true,
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Select up to $maxitems tags',
                  ),
                ),
                findSuggestions: ActivityService.getCategoriesByCountry(
                    isoCountryCode:
                        user.user.person.location!["isoCountryCode"]),
                additionCallback: (name) {
                  return Category.fromString(name: name.trim());
                },
                onAdded: (category) {
                  ActivityService.addCategory(
                      category: category,
                      isoCountryCode:
                          user.user.person.location!["isoCountryCode"]);
                  return category;
                },
                configureSuggestion: (category) {
                  return SuggestionConfiguration(
                    title: Row(children: [
                      Text(category.name),
                    ]),
                    dense: true,
                    additionWidget: Chip(
                      avatar: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      label: Text('Create'),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                },
                configureChip: (category) {
                  return ChipConfiguration(
                    label: Text(category.name),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    deleteIconColor: Theme.of(context).colorScheme.secondary,
                  );
                },
                wrapConfiguration:
                    WrapConfiguration(spacing: 10, runSpacing: 0),
                onChanged: () => setState(() {
                  if (_selectedCategories.length > maxitems) {
                    _selectedCategories.removeLast();
                  }
                }),
              ),
              ButtonPrimary(
                  onPressed: () {
                    _selectedCategories.forEach((cat) =>
                        analytics.logEvent(name: "actcat_${cat.name}"));
                    myActivities.updateActivity(categories: _selectedCategories)
                        // Need to await because otherwise no activit id and
                        // likestream will fail
                        .then((_) {
                      if (RemoteConfigService.remoteConfig
                              .getBool("forceAddActivity") &&
                          !user.user.finishedSignupFlow) {
                        Navigator.pushNamed(context, '/signup/signupexplainer');
                      } else {
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                      }
                    }).catchError((error) => LoggerService.log(
                            'Failed to update activity\n' + error.toString(),
                            level: "e"));
                  },
                  text: 'Finish',
                  active: _selectedCategories.length > 0),
            ],
          ),
        );
      });
    });
  }
}
