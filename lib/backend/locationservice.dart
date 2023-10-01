import 'package:geocoding/geocoding.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:letss_app/models/latlonglocation.dart';
import 'package:letss_app/models/searchlocation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  static Future<Placemark> getPlacemark(
      {required double latitude, required double longitude}) async {
    Placemark placemark = (await placemarkFromCoordinates(latitude, longitude,
        localeIdentifier: "en"))[0];

    return placemark;
  }

  static Future<Map<String, dynamic>> generateLocation(
      {required double latitude, required double longitude}) async {
    Map<String, dynamic> location = {};
    Placemark placemark =
        await getPlacemark(latitude: latitude, longitude: longitude);
    location["isoCountryCode"] = placemark.isoCountryCode;
    location["country"] = placemark.country;
    location["administrativeArea"] = placemark.administrativeArea;
    location["subAdministrativeArea"] = placemark.subAdministrativeArea;
    location["locality"] = placemark.locality;
    location["subLocality"] = placemark.subLocality;
    // two decimal places = 1km precision (according to ChatGPT)
    location["latitude"] = (latitude * 100).round()/100.0;
    location["longitude"] = (longitude * 100).round()/100.0;

    return location;
  }

  static Future<List<SearchLocation>> getLocations(String filter) async {
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

  static Future<LatLongLocation?> getLatLong(SearchLocation location) async {
    var googlePlace = FlutterGooglePlacesSdk(dotenv.env['GOOGLE_API']!);

    var result = await googlePlace
        .fetchPlace(location.id, fields: [PlaceField.Location]);
    if (result.place != null && result.place!.latLng != null) {
      return LatLongLocation(
          latitude: result.place!.latLng!.lat,
          longitude: result.place!.latLng!.lng);
    }
    return null;
  }
}
