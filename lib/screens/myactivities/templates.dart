import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/models/template.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../backend/activityservice.dart';
import '../../models/category.dart';
import '../widgets/tiles/textheaderscreen.dart';

Widget _buildTemplate(Template template, MyActivitiesProvider myActs,
    BuildContext context, bool first,
    {bool clickable = true}) {
  List<Widget> widgets = [];
  if (!first) {
    widgets.add(
      Divider(),
    );
  }
  widgets.add(ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      title: Text(template.name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold)),
      subtitle: clickable
          ? Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: template.sponsored ? "Promoted  " : "",
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                  text: template.description,
                )
              ]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: clickable
          ? IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                myActs.editActivityFromTemplate(context, template);
              })
          : null));

  return Column(children: widgets);
}

Widget _buildContent(
    UserProvider user, MyActivitiesProvider myActs, BuildContext context) {
  int nItems = 10;
  TextStyle selectedTextStyle = Theme.of(context).textTheme.headlineSmall!;
  TextStyle unselectedTextStyle =
      selectedTextStyle.copyWith(color: Colors.grey);
  Category? selected = myActs.searchParameters.category;
  final TextEditingController _controller = TextEditingController();
  return Column(children: [
    TypeAheadField(
      hideOnError: true,
      hideOnEmpty: false,
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          controller: _controller,
          decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              label: Text(
                selected == null ? 'Search by interest' : selected.name,
                style:
                    selected == null ? unselectedTextStyle : selectedTextStyle,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIcon: selected == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => myActs.searchParameters =
                          SearchParameters(
                              locality: user.user.person.location!["locality"],
                              category: null),
                    ))),
      suggestionsCallback: (pattern) async {
        if (pattern.length == 0) {
          return user.user.person.interests.take(nItems);
        } else {
          return await ActivityService.getCategoriesByCountry(
                  isoCountryCode:
                      user.user.person.location!["isoCountryCode"])(pattern)
              .then((categories) => categories.take(nItems).toList());
        }
      },
      itemBuilder: (context, Category? cat) {
        return ListTile(title: Text(cat == 0 ? "" : cat!.name));
      },
      noItemsFoundBuilder: (context) => Container(),
      onSuggestionSelected: (Category? cat) {
        _controller.clear();
        myActs.searchParameters = SearchParameters(
            locality: user.user.person.location!["locality"], category: cat);
      },
    ),
    const SizedBox(height: 10),
    Expanded(
        child: FutureBuilder<List<Template>>(
            future: myActs.searchTemplates(),
            initialData: [],
            builder: (BuildContext context,
                AsyncSnapshot<List<Template>> templates) {
              if (templates.hasData && templates.data!.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) =>
                      _buildTemplate(templates.data!.elementAt(index), myActs,
                          context, index == 0),
                  itemCount: templates.data!.length,
                  reverse: false,
                );
              } else if (templates.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return Container();
              }
            })),
  ]);
}

class Templates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<MyActivitiesProvider>(builder: (context, myActs, child) {
        // Initially set to "NONE" when locality of user not known
        if (myActs.searchParameters.locality == "NONE") {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            myActs.searchParameters = SearchParameters(
                locality: user.user.person.location!["locality"]);
          });
        }
        return Scaffold(
            body: SafeArea(
                child: TextHeaderScreen(
                    back: true,
                    header: "Ideas",
                    child: _buildContent(user, myActs, context))));
      });
    });
  }
}
