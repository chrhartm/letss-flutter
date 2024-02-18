import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:letss_app/models/locationinfo.dart';
import 'package:letss_app/models/searchlocation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  static Future<LocationInfo?> getLocationFromLatLng(
      double latitude, double longitude) async {
    // can't trust this because different on iOS and Android 
    Placemark placemark =
        (await placemarkFromCoordinates(latitude, longitude))[0];
    return getLocations(
            "${placemark.subLocality}, ${placemark.locality}, ${placemark.country}")
        .then((locations) async {
      if (locations.length > 0) {
        LocationInfo? loc = await getLocationInfo(locations[0]);
        if (loc != null) {
          LocationInfo newLoc = LocationInfo(
              administrativeArea: loc.administrativeArea,
              country: loc.country,
              isoCountryCode: loc.isoCountryCode,
              latitude: (latitude * 100).round() / 100.0,
              locality: loc.locality,
              longitude: (longitude * 100).round() / 100.0,
              subAdministrativeArea: loc.subAdministrativeArea,
              subLocality: loc.subLocality);
          return newLoc;
        }
        return loc;
      }
      return null;
    });
  }

  static Future<List<SearchLocation>> getLocations(String filter) async {
    if (filter.isEmpty) return [];
    // get locations from google maps api
    List<SearchLocation> locations = [];
    var googlePlace = FlutterGooglePlacesSdk(dotenv.env['GOOGLE_API']!);
    var result = await googlePlace.findAutocompletePredictions(filter);
    for (var prediction in result.predictions) {
      locations.add(SearchLocation(
          description: prediction.fullText, id: prediction.placeId));
    }
    return locations;
  }

  static Future<LocationInfo?> getLocationInfo(SearchLocation location) async {
    var googlePlace = FlutterGooglePlacesSdk(dotenv.env['GOOGLE_API']!);

    var result = await googlePlace.fetchPlace(location.id, fields: [
      PlaceField.Location,
      PlaceField.Id,
      PlaceField.AddressComponents
    ]);
    if (result.place != null &&
        result.place!.latLng != null &&
        result.place!.addressComponents != null) {
      Place place = result.place!;
      String isoCountryCode = "";
      String country = "";
      String administrativeArea = "";
      String subAdministrativeArea = "";
      String locality = "";
      String subLocality = "";
      for (var component in place.addressComponents!) {
        if (component.types.contains("country")) {
          isoCountryCode = component.shortName;
          country = component.name;
        } else if (component.types.contains("administrative_area_level_1")) {
          administrativeArea = component.name;
        } else if (component.types.contains("administrative_area_level_2")) {
          subAdministrativeArea = component.name;
        } else if (component.types.contains("locality")) {
          locality = component.name;
        } else if (component.types.contains("sublocality")) {
          subLocality = component.name;
        } else if (component.types.contains("postal_town") &&
            locality.isEmpty) {
          locality = component.name;
        }
      }
      return LocationInfo(
          // two decimal places = 1km precision (according to ChatGPT)
          latitude: (place.latLng!.lat * 100).round() / 100.0,
          longitude: (place.latLng!.lng * 100).round() / 100.0,
          isoCountryCode: isoCountryCode,
          country: country,
          administrativeArea: administrativeArea,
          subAdministrativeArea: subAdministrativeArea,
          locality: locality,
          subLocality: subLocality);
    }
    return null;
  }
}
