import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/models/template.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/other/basiclisttile.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../backend/activityservice.dart';
import '../../models/category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget _buildTemplate(Template template, MyActivitiesProvider myActs,
    BuildContext context, bool first,
    {bool clickable = true}) {
  List<Widget> widgets = [];
  widgets.add(BasicListTile(
      title: template.name,
      leading: Provider.of<UserProvider>(context, listen: false)
          .user
          .person
          .thumbnail,
      noPadding: true,
      primary: true,
      subtitle:
          clickable ? template.categories.map((e) => e.name).join(", ") : null,
      onTap: clickable
          ? () {
              myActs.editActivityFromTemplate(context, template);
            }
          : null));

  return Column(children: widgets);
}

Widget _buildContent(
    UserProvider user, MyActivitiesProvider myActs, BuildContext context) {
  int nItems = 10;
  TextStyle selectedTextStyle = Theme.of(context).textTheme.headlineSmall!;
  TextStyle unselectedTextStyle =
      selectedTextStyle.copyWith(color: Colors.grey);
  Category? selected = myActs.ideaSearchParameters.category;
  final TextEditingController controller = TextEditingController();
  return Column(children: [
    TypeAheadField(
      hideOnError: true,
      hideOnEmpty: false,
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              label: Text(
                selected == null
                    ? AppLocalizations.of(context)!.templateSearchLabel
                    : selected.name,
                style:
                    selected == null ? unselectedTextStyle : selectedTextStyle,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              suffixIcon: selected == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => myActs.ideaSearchParameters =
                          SearchParameters(
                              locality: user.user.person.location!.locality,
                              language: Localizations.localeOf(context),
                              category: null),
                    ))),
      suggestionsCallback: (pattern) async {
        List<Category> categories =
            await ActivityService.getCategoriesByCountry(
                    isoCountryCode:
                        user.user.person.location!.isoCountryCode)(pattern)
                .then((categories) => categories.take(nItems).toList());
        if (pattern.isEmpty && user.user.person.hasInterests) {
          List<Category> mycategories =
              user.user.person.interests!.take(nItems).toList();
          categories.removeWhere((cat) => mycategories.contains(cat));
          mycategories.addAll(categories);
          categories = mycategories;
        }
        return categories;
      },
      itemBuilder: (context, Category? cat) {
        return ListTile(title: Text(cat == null ? "" : cat.name));
      },
      noItemsFoundBuilder: (context) => Container(),
      onSuggestionSelected: (Category? cat) {
        controller.clear();
        myActs.ideaSearchParameters = SearchParameters(
            locality: user.user.person.location!.locality,
            language: Localizations.localeOf(context),
            category: cat);
      },
    ),
    const SizedBox(height: 10),
    Expanded(
        child: FutureBuilder<List<Template>>(
            future: myActs.searchTemplates(
                withGeneric: user.user.person.location == null
                    ? true
                    : !user.user.person.location!.isVirtual),
            initialData: [],
            builder: (BuildContext context,
                AsyncSnapshot<List<Template>> templates) {
              if (templates.hasData && templates.data!.isNotEmpty) {
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
                return Loader(padding: 20);
              } else {
                return BasicListTile(
                  title: AppLocalizations.of(context)!.templateNoTemplatesTitle,
                  subtitle:
                      AppLocalizations.of(context)!.templateNoTemplatesSubtitle,
                  onTap: () =>
                      Provider.of<MyActivitiesProvider>(context, listen: false)
                          .addNewActivity(context),
                  noPadding: true,
                  primary: true,
                );
              }
            })),
  ]);
}

class Templates extends StatelessWidget {
  final bool back;

  const Templates({super.key,this.back = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<MyActivitiesProvider>(builder: (context, myActs, child) {
        // Initially set to "NONE" when locality of user not known
        if (myActs.ideaSearchParameters.locality == "NONE") {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            myActs.ideaSearchParameters = SearchParameters(
                locality: user.user.person.location!.locality,
                language: Localizations.localeOf(context));
          });
        }
        return MyScaffold(
            body: HeaderScreen(
                back: back,
                title: AppLocalizations.of(context)!.templateSearchHeader,
                child: _buildContent(user, myActs, context)));
      });
    });
  }
}
