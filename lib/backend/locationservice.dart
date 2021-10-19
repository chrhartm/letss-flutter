import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../backend/loggerservice.dart';

class LocationService {
  static Map<String, dynamic> generateGeoHash(
      {required double latitude, required double longitude}) {
    final geo = Geoflutterfire();
    GeoFirePoint myLocation =
        geo.point(latitude: latitude, longitude: longitude);
    return myLocation.data;
  }

  static Future<Placemark> getPlacemark(
      {required double latitude, required double longitude}) async {
    Placemark placemark = (await placemarkFromCoordinates(latitude, longitude,
        localeIdentifier: "en"))[0];

    return placemark;
  }

  static Future<Map<String, dynamic>> generateLocation(
      {required double latitude, required double longitude}) async {
    Map<String, dynamic> location =
        generateGeoHash(latitude: latitude, longitude: longitude);
    Placemark placemark =
        await getPlacemark(latitude: latitude, longitude: longitude);
    location["isoCountryCode"] = placemark.isoCountryCode;
    location["country"] = placemark.country;
    location["administrativeArea"] = placemark.administrativeArea;
    location["subAdministrativeArea"] = placemark.subAdministrativeArea;
    location["locality"] = placemark.locality;
    location["subLocality"] = placemark.subLocality;

    logger.d(location);

    return location;
  }
}
