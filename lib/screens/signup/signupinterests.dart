import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/userprovider.dart';
import '../../backend/activityservice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpInterests extends StatelessWidget {
  final bool signup;

  const SignUpInterests({this.signup = true, super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: HeaderScreen(
        top: '😍',
        title: AppLocalizations.of(context)!.signupInterestsTitle,
        subtitle: AppLocalizations.of(context)!.signupInterestsSubtitle,
        back: true,
        child: TagSelector(signup: signup),
      ),
    );
  }
}

class TagSelector extends StatefulWidget {
  final bool signup;

  const TagSelector({required this.signup, super.key});

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
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (!init) {
        init = true;
        _selectedCategories = List.from(
            user.user.person.hasInterests ? user.user.person.interests! : []);
      }

      // Wrap prevented bottomoverflow issues of Column
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
                    .signupInterestsLabel(maxitems.toString()),
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
                      .signupInterestsCreateCategory),
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
              user.updatePerson(interests: _selectedCategories);
              if (widget.signup) {
                Navigator.pushNamed(context, '/signup/pic');
              } else {
                Navigator.popUntil(
                    context, (Route<dynamic> route) => route.isFirst);
              }
            },
            text: widget.signup
                ? AppLocalizations.of(context)!.signupInterestsNextSignup
                : AppLocalizations.of(context)!.signupInterestsNextProfile,
            active: _selectedCategories.length < 10 &&
                _selectedCategories.isNotEmpty,
          ),
        ],
      );
    });
  }
}
