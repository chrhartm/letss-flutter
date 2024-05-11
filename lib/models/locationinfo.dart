import 'dart:math';

class LocationInfo {
  final double latitude;
  final double longitude;
  final String isoCountryCode;
  final String _country;
  final String _administrativeArea;
  final String _subAdministrativeArea;
  final String locality;
  final String _subLocality;

  LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.isoCountryCode,
    required String country,
    required String administrativeArea,
    required String subAdministrativeArea,
    required this.locality,
    required String subLocality,
  })  : _country = country,
        _administrativeArea = administrativeArea,
        _subAdministrativeArea = subAdministrativeArea,
        _subLocality = subLocality;

  LocationInfo.fromVirtual({required String name})
      : latitude = 0.0,
        longitude = 0.0,
        isoCountryCode = name,
        _country = "Virtual",
        _administrativeArea = "",
        _subAdministrativeArea = "",
        locality = name,
        _subLocality = "";

  LocationInfo.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] ?? 0,
        longitude = json['longitude'] ?? 0,
        isoCountryCode = json['isoCountryCode'] ?? "",
        _country = json['country'] ?? "",
        _administrativeArea = json['administrativeArea'] ?? "",
        _subAdministrativeArea = json['subAdministrativeArea'] ?? "",
        locality = json['locality'] ?? "",
        _subLocality = json['subLocality'] ?? "";

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'isoCountryCode': isoCountryCode,
        'country': _country,
        'administrativeArea': _administrativeArea,
        'subAdministrativeArea': _subAdministrativeArea,
        'locality': locality,
        'subLocality': _subLocality,
      };

  bool equals(LocationInfo other) {
    return this.latitude == other.latitude &&
        this.longitude == other.longitude &&
        this.locality == other.locality &&
        this.isoCountryCode == other.isoCountryCode;
  }

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

  get isVirtual {
    return this.latitude == 0.0 && this.longitude == 0.0;
  }

  String generateLocality() {
    return locality;
  }

  // If otherLocation is null, then show either locality or sublocality.
  // If otherLocation exists and both have latitude and longitude, then calculate distance.
  String generateLocation(
      {LocationInfo? otherLocation = null, bool long = false}) {
    bool localityExists = this.locality != "";
    bool subLocalityExists = this._subLocality != "";
    if (otherLocation != null && this.isVirtual) {
      return this.locality;
    }
    if (!localityExists && !subLocalityExists) {
      return "";
    }
    // Only for screenshots
    // return "";
    // show city here
    if (otherLocation != null &&
        otherLocation.latitude != 0 &&
        this.latitude != 0) {
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
        return this._subLocality + ", " + this.locality;
      } else {
        return this._subLocality;
      }
    }
  }
}
