import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/activities/widgets/searchcard.dart';
import 'package:letss_app/screens/activities/widgets/searchDisabled.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../backend/activityservice.dart';
import '../../backend/loggerservice.dart';
import '../../models/category.dart';
import '../widgets/tiles/textheaderscreen.dart';

Widget _buildActivity(
    Activity act, ActivitiesProvider acts, BuildContext context, bool first,
    {bool clickable = true}) {
  List<Widget> widgets = [];
  LoggerService.log(act.toJson().toString());
  if (!first) {
    widgets.add(
      Divider(),
    );
  }
  widgets.add(ListTile(
    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    leading: act.person.thumbnail,
    title: Text(act.name,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(fontWeight: FontWeight.bold)),
    subtitle: clickable
        ? Text(
            act.person.name +
                act.person.supporterBadge +
                ", ${act.person.age}" +
                ", " +
                act.locationString,
            maxLines: 1,
            overflow: TextOverflow.ellipsis)
        : null,
    onTap: clickable
        ? () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: '/search/activity'),
                    builder: (context) => SearchCard(act)));
          }
        : null,
  ));
  return Column(children: widgets);
}

Widget _buildContent(
    UserProvider user, ActivitiesProvider acts, BuildContext context) {
  int nItems = 10;
  TextStyle selectedTextStyle = Theme.of(context).textTheme.headline5!;
  TextStyle unselectedTextStyle =
      selectedTextStyle.copyWith(color: Colors.grey);
  Category? selected = acts.searchParameters.category;
  final TextEditingController _controller = TextEditingController();
  if (user.searchEnabled) {
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
                                locality:
                                    user.user.person.location!["locality"],
                                category: null),
                      ))),
        suggestionsCallback: (pattern) async {
          return await ActivityService.getCategoriesByCountry(
                  isoCountryCode:
                      user.user.person.location!["isoCountryCode"])(pattern)
              .then((categories) => categories.take(nItems).toList());
        },
        itemBuilder: (context, Category? cat) {
          return ListTile(title: Text(cat == 0 ? "" : cat!.name));
        },
        noItemsFoundBuilder: (context) =>
            ListTile(title: Text("No interest found")),
        onSuggestionSelected: (Category? cat) {
          analytics.logEvent(name: "search_${cat == null ? "null" : cat.name}");
          _controller.clear();
          acts.searchParameters = SearchParameters(
              locality: user.user.person.location!["locality"], category: cat);
        },
      ),
      const SizedBox(height: 10),
      FutureBuilder<List<Activity>>(
          future: acts.searchActivities(),
          initialData: [],
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> activities) {
            if (activities.hasData && activities.data!.length > 0) {
              LoggerService.log("activities.data: ${activities.data}");
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int index) =>
                    _buildActivity(activities.data!.elementAt(index), acts,
                        context, index == 0),
                itemCount: activities.data!.length,
                reverse: false,
              );
            } else if (activities.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              return Container();
            }
          }),
    ]);
  } else {
    return SearchDisabled();
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<ActivitiesProvider>(builder: (context, acts, child) {
        // Initially set to "NONE" when locality of user not known
        if (acts.searchParameters.locality == "NONE") {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            acts.searchParameters = SearchParameters(
                locality: user.user.person.location!["locality"]);
          });
        }
        return Scaffold(
            body: SafeArea(
                child: TextHeaderScreen(
                    back: true,
                    header: "Search",
                    child: SingleChildScrollView(
                        child: _buildContent(user, acts, context)))));
      });
    });
  }
}
