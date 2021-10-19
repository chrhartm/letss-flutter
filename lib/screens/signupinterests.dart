import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../widgets/buttonprimary.dart';
import '../provider/userprovider.dart';
import '../backend/activityservice.dart';

class SignUpInterests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          title: 'What do you like? 👀',
          subtitle: 'We will match you to activities based on your interests.',
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (!init) {
        init = true;
        _selectedCategories = List.from(user.user.person.interests);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlutterTagging<Category>(
            initialItems: _selectedCategories,
            textFieldConfiguration: TextFieldConfiguration(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search tags',
                labelText: 'Select tags',
              ),
            ),
            findSuggestions: ActivityService.getCategories,
            additionCallback: (name) {
              return Category.fromString(name: name);
            },
            onAdded: (category) {
              ActivityService.addCategory(category);
              return category;
            },
            configureSuggestion: (category) {
              return SuggestionConfiguration(
                title: Row(children: [
                  Text(category.name),
                  const SizedBox(width: 10),
                  Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: 15 * category.popularity,
                          height: 15 * category.popularity,
                          decoration: new BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant,
                              shape: BoxShape.circle)))
                ]),
                additionWidget: Chip(
                  avatar: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: Text('Add'),
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
          ),
          ButtonPrimary(
            onPressed: () {
              user.update(interests: _selectedCategories);
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            },
            text: 'Finish',
          ),
        ],
      );
    });
  }
}
