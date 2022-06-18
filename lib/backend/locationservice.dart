import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';
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

    return location;
  }

  static Future<List<SearchLocation>> getLocations(String filter) async {
    // get locations from google maps api
    List<SearchLocation> locations = [];
    var googlePlace = GooglePlace(dotenv.env['GOOGLE_API']!);
    var result = await googlePlace.autocomplete.get(filter);
    if (result != null && result.predictions != Null) {
      for (var prediction in result.predictions!) {
        locations.add(SearchLocation(
            description: prediction.description!, id: prediction.placeId!));
      }
    }
    return locations;
  }

  static Future<LatLongLocation?> getLatLong(SearchLocation location) async {
    var googlePlace = GooglePlace(dotenv.env['GOOGLE_API']!);

    var result = await googlePlace.details.get(location.id, fields: "geometry");
    if (result != null) {
      return LatLongLocation(
          latitude: result.result!.geometry!.location!.lat!,
          longitude: result.result!.geometry!.location!.lng!);
    }
    return null;  }
}
