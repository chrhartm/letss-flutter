import 'package:flutter/material.dart';
import 'package:letss_app/backend/locationservice.dart';
import 'package:letss_app/models/latlonglocation.dart';
import 'package:letss_app/models/searchlocation.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../widgets/tiles/textheaderscreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Travel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return MyScaffold(
              body: TextHeaderScreen(
                  back: true,
                  header: AppLocalizations.of(context)!.travelHeader,
                  child: Column(children: [
                    TypeAheadField(
                      hideOnError: true,
                      hideOnEmpty: false,
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          label: Text(
                            AppLocalizations.of(context)!.travelAction,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await LocationService.getLocations(pattern);
                      },
                      itemBuilder: (context, SearchLocation location) {
                        return ListTile(title: Text(location.description));
                      },
                      noItemsFoundBuilder: (context) => Container(
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(AppLocalizations.of(context)!
                                  .travelNoLocationFound))),
                      onSuggestionSelected: (SearchLocation location) async {
                        context.loaderOverlay.show();

                        LatLongLocation? loc =
                            await LocationService.getLatLong(location);
                        if (loc != null) {
                          user
                              .updatePerson(
                                  latitude: loc.latitude,
                                  longitude: loc.longitude,
                                  context: context)
                              .then((_) => Provider.of<ActivitiesProvider>(
                                      context,
                                      listen: false)
                                  .resetAfterLocationChange())
                              .then((_) {
                            context.loaderOverlay.hide();
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            context.loaderOverlay.hide();
                            Navigator.pop(context);
                          });
                        } else {
                          context.loaderOverlay.hide();

                          Navigator.pop(context);
                        }
                      },
                    ),
                  ])));
    });
  }
}
