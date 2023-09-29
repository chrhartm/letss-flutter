import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../provider/navigationprovider.dart';
import '../widgets/other/loader.dart';
import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../backend/activityservice.dart';
import '../../provider/myactivitiesprovider.dart';
import '../../provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditActivityCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        overlayColor: Colors.black.withOpacity(0.6),
        child: Scaffold(
          body: SafeArea(
            child: SubtitleHeaderScreen(
              top: "🏷️",
              title: AppLocalizations.of(context)!.editActivityCategoriesTitle,
              subtitle:
                  AppLocalizations.of(context)!.editActivityCategoriesSubtitle,
              child: TagSelector(),
              back: true,
            ),
          ),
        ));
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
        _selectedCategories = List.from(myActivities.editActivity.hasCategories
            ? myActivities.editActivity.categories!
            : []);
      }
      return Consumer<UserProvider>(builder: (context, user, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlutterTagging<Category>(
                initialItems: _selectedCategories,
                hideOnError: true,
                hideOnEmpty: true,
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    labelText: AppLocalizations.of(context)!
                        .editActivityCategoriesAction(maxitems.toString()),
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
                      label: Text(AppLocalizations.of(context)!
                          .editActivityCategoriesCreateCategory),
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
                    myActivities
                        .updateActivity(categories: _selectedCategories)
                        // Need to await because otherwise no activit id and
                        // likestream will fail
                        .then((activity) {
                      UserProvider user =
                          Provider.of<UserProvider>(context, listen: false);
                      if (!user.user.finishedSignupFlow) {
                        user.user.finishedSignupFlow = true;
                        user.forceNotify();
                      }

                      Provider.of<NavigationProvider>(context, listen: false)
                          .navigateTo("/myactivities");
                      Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst);
                    }).catchError((error) {
                      LoggerService.log('Couldn\'t to update idea', level: "w");
                    });
                  },
                  text:
                      AppLocalizations.of(context)!.editActivityCategoriesNext,
                  active: _selectedCategories.length < 10),
            ],
          ),
        );
      });
    });
  }
}
