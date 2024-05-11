import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';

import 'package:letss_app/backend/loggerservice.dart';

class GenericConfigService {
  static Future init() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      'welcome_activities': """{
        "activities": [
          "Let's play tennis this weekend",
          "Let's go to a reggae concert",
          "Let's be language buddies for Dutch-English",
          "Let's go to the zoo and take pictures",
          "Let's do a barista course",
          "Let's go to an escape room",
          "Let's learn to dance salsa",
          "Let's hike in nature",
          "Let's go to a museum",
          "Let's become wine sommeliers",
          "Let's go do something"
        ]
      }""",
      "urlTnc": "https://letss-app.unicornplatform.page/terms",
      "urlPrivacy": "https://letss-app.unicornplatform.page/privacy",
      "urlSupport": "mailto:support@letss.app",
      "urlWebsite": "https://letss-app.unicornplatform.page/",
      "urlFAQ": "https://letss-app.unicornplatform.page/faq",
      "urlLogo":
          "https://firebasestorage.googleapis.com/v0/b/letss-11cc7.appspot.com/o/activityImages%2F000Logo.png?alt=media&token=b1ae1562-a536-48d4-8758-8fdaf9fe9b7b",
      "supportPitch":
          "Enjoying our app? Buy us a coffee and get a supporter badge on your profile.",
    });

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate().onError(
      (error, stackTrace) {
        LoggerService.log("Error fetching remote config: $error");
        return true;
      },
    );
  }

  static FirebaseRemoteConfig get config {
    return FirebaseRemoteConfig.instance;
  }

  static Map<String, dynamic> getJson(String key) {
    return json.decode(config.getString(key));
  }
}
