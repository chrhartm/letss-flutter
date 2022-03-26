import 'package:flutter/material.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/search/widgets/searchDisabled.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../models/category.dart';
import '../widgets/tiles/textheaderscreen.dart';

Widget _buildContent(UserProvider user) {
  int nItems = 10;
  if (user.searchEnabled) {
    return Column(children: [
      DropdownSearch<Category>(
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
            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
            labelText: null,
          ),
        ),
        dropdownSearchDecoration: InputDecoration(
          label: Text("Activity category"),
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
        onChanged: (Category? cat) =>
            cat == null ? print("Cat null") : print(cat.name),
      ),
    ]);
  } else {
    return SearchDisabled();
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: TextHeaderScreen(
              back: false, header: "Search", child: _buildContent(user)));
    });
  }
}
