import 'package:flutter/material.dart';
import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../provider/navigationprovider.dart';
import '../widgets/screens/subtitleheaderscreen.dart';
import '../widgets/buttons/buttonprimary.dart';
import '../../provider/userprovider.dart';
import '../../backend/activityservice.dart';

class SignUpInterests extends StatelessWidget {
  final bool signup;

  SignUpInterests({this.signup = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: '😍',
          title: 'What are you interested in?',
          subtitle:
              'We will show you activities based on the interests you put here.',
          child: TagSelector(signup: signup),
          back: true,
        ),
      ),
    );
  }
}

class TagSelector extends StatefulWidget {
  final bool signup;

  const TagSelector({required this.signup, Key? key}) : super(key: key);

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
        _selectedCategories = List.from(user.user.person.interests);
      }

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
                  labelText: 'Select up to $maxitems interests',
                ),
              ),
              findSuggestions: ActivityService.getCategoriesByCountry(
                  isoCountryCode: user.user.person.location!["isoCountryCode"]),
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
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
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
                    Provider.of<NavigationProvider>(context, listen: false)
                        .showWalkthrough = true;
                  }
                  // Need no signup logic, pops back either way
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
                text: widget.signup ? 'Finish' : 'Save',
                active: _selectedCategories.length > 0),
          ],
        ),
      );
    });
  }
}
