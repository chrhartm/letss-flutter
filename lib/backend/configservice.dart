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
    if (DateTime.now().difference(instance._lastUpdated).inMinutes > 10) {
      reloadConfig();
    }
    return instance._config;
  }

  static void reloadConfig() async {
    instance._lastUpdated = DateTime.now();
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('user-getConfig');
    try {
      final results = await callable();
        instance._config =
            Config.fromJson(json: results.data);
      
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log("Error retrieving config\n${e.message!}", level: "i");
    } catch (err) {
      LoggerService.log("Error retrieving config\n$err", level: "i");
    }
  }

  static void reset() {
    instance._config = Config();
    instance._lastUpdated = DateTime.now().subtract(Duration(days: 100));
  }
}
