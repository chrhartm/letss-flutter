import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../provider/navigationprovider.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../backend/activityservice.dart';
import '../../provider/myactivitiesprovider.dart';
import '../../provider/userprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditActivityCategories extends StatelessWidget {
  const EditActivityCategories({super.key});
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: "#️⃣",
        title: AppLocalizations.of(context)!.editActivityCategoriesTitle,
        subtitle: AppLocalizations.of(context)!.editActivityCategoriesSubtitle,
        back: true,
        child: TagSelector(),
      ),
    );
  }
}

class TagSelector extends StatefulWidget {
  const TagSelector({super.key});

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
        return Wrap(
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
                  isoCountryCode: user.user.person.location!.isoCountryCode),
              additionCallback: (name) {
                return Category.fromString(name: name.trim());
              },
              onAdded: (category) {
                ActivityService.addCategory(
                    category: category,
                    isoCountryCode: user.user.person.location!.isoCountryCode);
                return category;
              },
              configureSuggestion: (category) {
                return SuggestionConfiguration(
                  title: Row(children: [
                    Expanded(
                        child: Text(
                      category.name,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ]),
                  dense: true,
                  additionWidget: Chip(
                    avatar: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(AppLocalizations.of(context)!
                        .editActivityCategoriesCreateCategory),
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    color: WidgetStateColor.resolveWith(
                        (states) => Theme.of(context).colorScheme.primary),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                );
              },
              configureChip: (category) {
                return ChipConfiguration(
                  label: Text(category.name),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  deleteIconColor: Theme.of(context).colorScheme.secondary,
                );
              },
              wrapConfiguration: WrapConfiguration(spacing: 10, runSpacing: 0),
              onChanged: () => setState(() {
                if (_selectedCategories.length > maxitems) {
                  _selectedCategories.removeLast();
                }
              }),
            ),
            ButtonPrimary(
              onPressed: () {
                bool pushAddFriends = user.user.finishedSignupFlow &&
                    !myActivities.editActivity.hasCategories;
                myActivities
                    .updateActivity(categories: _selectedCategories)
                    // Need to await because otherwise no activit id and
                    // likestream will fail
                    .then((activity) {
                  if (context.mounted) {
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
                    if (pushAddFriends) {
                      Navigator.pushNamed(context, '/myactivities/addfollowers',
                          arguments: activity);
                    }
                  }
                }).catchError((error) {
                  LoggerService.log('Couldn\'t to update idea', level: "w");
                });
              },
              text: AppLocalizations.of(context)!.editActivityCategoriesNext,
              active: _selectedCategories.length < 10 &&
                  _selectedCategories.isNotEmpty,
            ),
          ],
        );
      });
    });
  }
}
