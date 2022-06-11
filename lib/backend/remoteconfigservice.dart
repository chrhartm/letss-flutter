import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';

class RemoteConfigService {
  static Future init() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setDefaults(<String, dynamic>{
      'welcome_activities': """{
        "activities": [
          "Let's get rich and fly to Mars",
          "Let's be language buddies for French-Polish",
          "Let's forget the world over a boozy brunch",
          "Let's build a startup to connect people offline",
          "Let's go job shadowing at the chocolate factory",
          "Let's dress up as orks and play dungeons and dragons",
          "Let's get horses and ride through Mongolia",
          "Let's mine bitcoin with renewable energy",
          "Let's bake pretzels and host an Octoberfest",
          "Let's hit the gym once a week and get ripped",
          "Let's go do something"
        ]
      }""",
      "minChatsForReview": 3,
      "urlTnc": "https://letss-app.unicornplatform.page/terms",
      "urlPrivacy": "https://letss-app.unicornplatform.page/privacy",
      "urlSupport": "mailto:support@letss.app",
      "urlWebsite": "https://letss-app.unicornplatform.page/",
      "urlTransparency": "https://letss-app.unicornplatform.page/transparency",
      "urlFAQ": "https://letss-app.unicornplatform.page/faq",
      "forceAddActivity": false,
      "featureSearch": false,
      "searchDays": 360,
      "supportPitch":
          "Enjoying our app? Buy us a coffee and get a supporter badge on your profile.",
      "supportRequestInterval": 360,
    });

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
  }

  static FirebaseRemoteConfig get remoteConfig {
    return FirebaseRemoteConfig.instance;
  }

  static Map<String, dynamic> getJson(String key) {
    return json.decode(remoteConfig.getString(key));
  }
}
