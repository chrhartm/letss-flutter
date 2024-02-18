import 'dart:math';

class LocationInfo {
  final double latitude;
  final double longitude;
  final String isoCountryCode;
  final String country;
  final String administrativeArea;
  final String subAdministrativeArea;
  final String locality;
  final String subLocality;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.isoCountryCode,
    required this.country,
    required this.administrativeArea,
    required this.subAdministrativeArea,
    required this.locality,
    required this.subLocality,
  });

  LocationInfo.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] ?? 0,
        longitude = json['longitude'] ?? 0,
        isoCountryCode = json['isoCountryCode'] ?? "",
        country = json['country'] ?? "",
        administrativeArea = json['administrativeArea'] ?? "",
        subAdministrativeArea = json['subAdministrativeArea'] ?? "",
        locality = json['locality'] ?? "",
        subLocality = json['subLocality'] ?? "";

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'isoCountryCode': isoCountryCode,
        'country': country,
        'administrativeArea': administrativeArea,
        'subAdministrativeArea': subAdministrativeArea,
        'locality': locality,
        'subLocality': subLocality,
      };

  static double calculateDistance(latitude, longitude, latitude2, longitude2) {
    // Calculate approximate distance
    double p = 0.017453292519943295;
    double a = 0.5 -
        cos((latitude2 - latitude) * p) / 2 +
        cos(latitude * p) *
            cos(latitude2 * p) *
            (1 - cos((longitude2 - longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  // If otherLocation is null, then show either locality or sublocality.
  // If otherLocation exists and both have latitude and longitude, then calculate distance.
  String generateLocation(
      {LocationInfo? otherLocation = null, bool long = false}) {
    bool localityExists = this.locality != "";
    bool subLocalityExists = this.subLocality != "";
    if (!localityExists && !subLocalityExists) {
      return "";
    }
    // Only for screenshots
    // return "";
    // show city here
    if (otherLocation != null) {
      double distance = calculateDistance(otherLocation.latitude,
          otherLocation.longitude, this.latitude, this.longitude);
      if (distance < 1) {
        return "<1 km";
      } else {
        return distance.toStringAsFixed(1) + " km";
      }
    }
    if (!subLocalityExists) {
      return this.locality;
    } else {
      if (localityExists && long) {
        return this.subLocality + ", " + this.locality;
      } else {
        return this.subLocality;
      }
    }
  }
}
