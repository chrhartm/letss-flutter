import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/person.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/models/user.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/activities/widgets/searchcard.dart';
import 'package:letss_app/screens/myactivities/activityscreen.dart';
import 'package:letss_app/screens/widgets/other/basiclisttile.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../backend/activityservice.dart';
import '../../models/category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget _buildActivity({
  required Activity act,
  required ActivitiesProvider acts,
  required BuildContext context,
  required bool first, // was used to add divider
  required User user,
  required bool prompt,
}) {
  List<Widget> widgets = [];
  String userLocation = user.person.distanceString(act.location, reverse: true);

  String subtitle = !prompt
      ? act.person.name +
          act.person.supporterBadge +
          ", ${act.person.age}" +
          ", " +
          (userLocation.length > 0 && !user.person.location!.isVirtual
              ? userLocation
              : act.person.job)
      : act.person.name;
  if (act.description != null && act.description!.length > 0) {
    subtitle += '\n> ' + act.description!;
  }

  widgets.add(BasicListTile(
    noPadding: true,
    underlined: false,
    leading: act.thumbnail,
    title: act.name,
    subtitle: subtitle,
    primary: true,
    threeLines: foundation.kIsWeb,
    onTap: !prompt
        ? () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: '/search/activity'),
                    builder: (context) => SearchCard(act)));
          }
        : () {
            if (foundation.kIsWeb) {
              Uri uri = Uri.parse("https://letss.app");
              launchUrl(uri);
            } else {
              Provider.of<NavigationProvider>(context, listen: false)
                  .navigateTo('/templates');
            }
          },
  ));
  return Column(children: widgets);
}

Widget _buildContent(
    UserProvider user, ActivitiesProvider acts, BuildContext context) {
  int nItems = 10;
  int promptFrequency = 8;
  TextStyle selectedTextStyle = Theme.of(context).textTheme.headlineSmall!;
  TextStyle unselectedTextStyle =
      selectedTextStyle.copyWith(color: Colors.grey);
  Category? selected = acts.searchParameters.category;
  final TextEditingController controller = TextEditingController();
  Activity templatePrompt = Activity(
      categories: [],
      person: Person.emptyPerson(
          name: foundation.kIsWeb
              ? AppLocalizations.of(context)!.noSearchActivitiesWebSubtitle
              : AppLocalizations.of(context)!.noSearchActivitiesSubtitle),
      name: foundation.kIsWeb
          ? AppLocalizations.of(context)!.noSearchActivitiesWebTitle
          : AppLocalizations.of(context)!.noSearchActivitiesTitle,
      status: "ACTIVE",
      timestamp: DateTime.now(),
      uid: "",
      participants: [],
      description: null);

  List<Widget> widgets = [];
  if (foundation.kIsWeb) {
    widgets.add(const SizedBox(height: 10));
  } else {
    widgets.addAll([
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
                      ? AppLocalizations.of(context)!.searchByInterest
                      : selected.name,
                  style: selected == null
                      ? unselectedTextStyle
                      : selectedTextStyle,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: selected == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => acts.searchParameters =
                            SearchParameters(
                                locality: user.user.person.location!.locality,
                                category: null),
                      ))),
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty && user.user.person.hasInterests) {
            return user.user.person.interests!.take(nItems);
          } else {
            return await ActivityService.getCategoriesByCountry(
                    isoCountryCode:
                        user.user.person.location!.isoCountryCode)(pattern)
                .then((categories) => categories.take(nItems).toList());
          }
        },
        itemBuilder: (context, Category? cat) {
          return ListTile(title: Text(cat == null ? "" : cat.name));
        },
        noItemsFoundBuilder: (context) => ListTile(
            title: Text(AppLocalizations.of(context)!.searchNoInterest)),
        onSuggestionSelected: (Category? cat) {
          controller.clear();
          acts.searchParameters = SearchParameters(
              locality: user.user.person.location!.locality, category: cat);
        },
      ),
      const SizedBox(height: 10),
    ]);
  }
  widgets.addAll([
    Expanded(
      child: FutureBuilder<List<Activity>>(
          future: acts.searchActivities(),
          initialData: [],
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> activities) {
            if (activities.hasData && activities.data!.length > 0) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) {
                  int activityIndex = index - (index / promptFrequency).floor();
                  bool last = activityIndex >= activities.data!.length;
                  if (((index % promptFrequency) == (promptFrequency - 1)) ||
                      (promptFrequency > activities.data!.length && last)) {
                    return _buildActivity(
                        act: templatePrompt,
                        acts: acts,
                        context: context,
                        user: user.user,
                        first: index == 0,
                        prompt: true);
                  }
                  if (last) {
                    return const SizedBox(height: 10);
                  }
                  return _buildActivity(
                      act: activities.data!.elementAt(activityIndex),
                      acts: acts,
                      context: context,
                      user: user.user,
                      first: index == 0,
                      prompt: false);
                },
                itemCount: activities.data!.length +
                    (activities.data!.length / (promptFrequency - 1)).ceil(),
                reverse: false,
              );
            } else if (activities.connectionState == ConnectionState.waiting) {
              return Loader(padding: 20);
            } else {
              return _buildActivity(
                  act: templatePrompt,
                  acts: acts,
                  context: context,
                  user: user.user,
                  first: true,
                  prompt: true);
            }
          }),
    )
  ]);

  return Column(children: widgets);
}

class Search extends StatelessWidget {
  final bool back;

  Search({bool back = true}) : this.back = back;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<ActivitiesProvider>(builder: (context, acts, child) {
        // Initially set to "NONE" when locality of user not known
        if (acts.searchParameters.locality == "NONE") {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            acts.searchParameters =
                SearchParameters(locality: user.user.person.location!.locality);
          });
        }
        TextStyle style = Theme.of(context).textTheme.displayMedium!;

        // TODO if search is not main menu item, make MyScaffold again
        return Scaffold(
          body: HeaderScreen(
              back: this.back,
              title: AppLocalizations.of(context)!
                  .searchTitle(user.user.person.shortLocationString),
              titleWidget: Row(children: [
                Text(AppLocalizations.of(context)!.searchTitle(""),
                    style: style),
                Expanded(
                    child: GestureDetector(
                  child: Underlined(
                    text: user.user.person.shortLocationString,
                    style: style,
                    maxLines: 1,
                    underlined: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: foundation.kIsWeb
                      ? () {}
                      : () => Navigator.pushNamed(context, "/profile/location"),
                ))
              ]),
              child: _buildContent(user, acts, context)),
        );
      });
    });
  }
}
