import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/searchparameters.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/search/widgets/searchCard.dart';
import 'package:letss_app/screens/search/widgets/searchDisabled.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../models/category.dart';
import '../widgets/tiles/textheaderscreen.dart';

Widget _buildActivity(
    Activity act, ActivitiesProvider acts, BuildContext context, bool first,
    {bool clickable = true}) {
  List<Widget> widgets = [];
  if (!first) {
    widgets.addAll([
      const SizedBox(height: 2),
      Divider(),
      const SizedBox(height: 2),
    ]);
  }
  widgets.add(ListTile(
    leading: act.person.thumbnail,
    title: Text(act.name),
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

Widget _buildContent(UserProvider user, ActivitiesProvider acts) {
  int nItems = 10;
  if (user.searchEnabled) {
    return Column(children: [
      DropdownSearch<Category>(
          selectedItem: acts.searchParameters.category == null
              ? null
              : acts.searchParameters.category,
          mode: Mode.DIALOG,
          showSearchBox: true,
          showClearButton: true,
          searchDelay: Duration(milliseconds: 500),
          emptyBuilder: (context, str) =>
              Center(child: Text("No category found")),
          isFilteredOnline: true,
          popupSafeArea: PopupSafeAreaProps(
              top: true, bottom: true, left: true, right: true),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              labelText: null,
            ),
          ),
          dropDownButton: Icon(Icons.search),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            border: OutlineInputBorder(),
          ),
          onFind: (String? filter) async =>
              await ActivityService.getCategoriesByCountry(
                          isoCountryCode:
                              user.user.person.location!["isoCountryCode"])(
                      filter == null ? "" : filter)
                  .then((categories) => categories.take(nItems).toList()),
          itemAsString: (Category? cat) => cat == null ? "" : cat.name,
          onChanged: (Category? cat) {
            analytics.logEvent(
                name: "search_${cat == null ? "null" : cat.name}");
            acts.searchParameters = SearchParameters(
                locality: user.user.person.location!["locality"],
                category: cat);
          }),
      const SizedBox(height: 20),
      FutureBuilder<List<Activity>>(
          future: acts.searchActivities(),
          initialData: [],
          builder:
              (BuildContext context, AsyncSnapshot<List<Activity>> activities) {
            if (activities.hasData && activities.data!.length > 0) {
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
              return _buildActivity(
                  Activity.noActivityFound(), acts, context, true,
                  clickable: false);
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
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            acts.searchParameters = SearchParameters(
                locality: user.user.person.location!["locality"]);
          });
        }
        return Scaffold(
            body: TextHeaderScreen(
                back: false,
                header: "Search",
                child: _buildContent(user, acts)));
      });
    });
  }
}
