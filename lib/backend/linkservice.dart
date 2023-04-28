import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import '../models/person.dart';
import 'loggerservice.dart';
import '../models/activity.dart';

class LinkService {
  static Future<Uri> _generateLink(
      {required String link,
      String? campaign,
      SocialMetaTagParameters? socialTags}) async {
    Uri fallbackUrl = Uri.parse('https://letss.app/applink');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://letssapp.page.link',
        link: Uri.parse('https://letss.app' + link),
        androidParameters: AndroidParameters(
          packageName: 'com.letss.letssapp',
          minimumVersion: 1,
          fallbackUrl: fallbackUrl,
        ),
        iosParameters: IOSParameters(
          bundleId: 'com.letss.letssapp',
          minimumVersion: '1.0.1',
          fallbackUrl: fallbackUrl,
        ),
        googleAnalyticsParameters: campaign == null
            ? null
            : GoogleAnalyticsParameters(
                campaign: campaign,
                medium: 'social',
                source: 'letss-app',
              ),
        socialMetaTagParameters: socialTags);

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    LoggerService.log(
        "Sharing the URL:" + shortDynamicLink.shortUrl.toString());
    return shortDynamicLink.shortUrl;
  }

  static Future<Uri?> generateImage(
      {required Activity activity, required String persona}) async {
    HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: "europe-west1")
            .httpsCallable('activity-generateImage');
    Uri? url;
    try {
      final results = await callable({
        "activityId": activity.uid,
        "activityName": activity.name,
        "activityPersona": persona
      });
      url = Uri.parse(results.data["url"]);
    } on FirebaseFunctionsException catch (e) {
      LoggerService.log("Error generating share image\n${e.message!}",
          level: "i");
    } catch (err) {
      LoggerService.log("Error generating share image\n$err", level: "i");
    }
    return url;
  }

  static Future<void> shareActivity(
      {required Activity activity, required bool mine}) async {
    Uri? imageUrl =
        await generateImage(activity: activity, persona: activity.person.name);
    LoggerService.log(imageUrl.toString());
    SocialMetaTagParameters socialTags =
        SocialMetaTagParameters(title: activity.name, imageUrl: imageUrl);

    Uri link = await _generateLink(
        link: '/activity/${activity.uid}',
        campaign: mine ? 'share-mine' : 'share-other',
        socialTags: socialTags);
    return Share.share(link.toString());
  }

  static Future<void> shareProfile({required Person person}) async {
    Uri link = await _generateLink(
        link: '/profile/person/${person.uid}',
        campaign: 'share-profile',
        socialTags:
            SocialMetaTagParameters(title: "Follow ${person.name} on Letss"));
    return Share.share(link.toString());
  }
}
