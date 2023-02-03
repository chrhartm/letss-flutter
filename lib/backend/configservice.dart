import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:letss_app/backend/loggerservice.dart';

import '../models/config.dart';

class ConfigService {
  Config _config;
  DateTime _lastUpdated;
  ConfigService._()
      : _config = Config(),
        _lastUpdated = DateTime.now().subtract(Duration(days: 100));

  static final instance = ConfigService._();

  static Config get config {
    // TODO change to minutes
    if (DateTime.now().difference(instance._lastUpdated).inMinutes > 10) {
      reload_config();
      LoggerService.log("Updating Config\n${instance._lastUpdated.toString()}",
          level: "i");
    }
    return instance._config;
  }

  static void reload_config() async {
    instance._lastUpdated = DateTime.now();
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-getConfig');
    try {
      final results = await callable();
      if (results.data["code"] == 200) {
        instance._config =
            Config.fromJson(json: json.decode(results.data["data"]));
        LoggerService.log("config\n${results.data.toString()}", level: "i");
      } else {
        LoggerService.log(
            "Couldn't retrieve config\n${results.data.toString()}",
            level: "i");
      }
    } catch (err) {
      LoggerService.log("Error retrieving config\n$err", level: "i");
    }
  }

  static void reset() {
    instance._config = Config();
    instance._lastUpdated = DateTime.now().subtract(Duration(days: 100));
  }
}
