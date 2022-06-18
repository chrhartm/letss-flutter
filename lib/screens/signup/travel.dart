import 'package:flutter/material.dart';
import 'package:letss_app/backend/locationservice.dart';
import 'package:letss_app/models/latlonglocation.dart';
import 'package:letss_app/models/searchlocation.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../widgets/tiles/textheaderscreen.dart';

class Travel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: SafeArea(
              child: TextHeaderScreen(
                  back: true,
                  header: "Travel",
                  child: SingleChildScrollView(
                      child: Column(children: [
                    TypeAheadField(
                      hideOnError: true,
                      hideOnEmpty: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          label: Text('Search location'),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await LocationService.getLocations(pattern);
                      },
                      itemBuilder: (context, SearchLocation location) {
                        return ListTile(title: Text(location.description));
                      },
                      noItemsFoundBuilder: (context) => Container(),
                      onSuggestionSelected: (SearchLocation location) async {
                        LatLongLocation? loc =
                            await LocationService.getLatLong(location);
                        if (loc != null) {
                          user.updatePerson(
                              latitude: loc.latitude, longitude: loc.longitude);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ])))));
    });
  }
}
