import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import 'loggerservice.dart';
import '../models/activity.dart';

class LinkService {
  static Future<Uri> generateActivityLink(
      {required Activity activity, required bool mine, Uri? imageUrl}) async {
    String uid = activity.uid;

    Uri fallbackUrl = Uri.parse('https://letss.app/applink');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://letssapp.page.link',
      link: Uri.parse('https://letss.app/activity/$uid'),
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
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: mine ? 'share-mine' : 'share-other',
        medium: 'social',
        source: 'letss-app',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: activity.name, imageUrl: imageUrl),
    );

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
    Uri? imageUrl = await generateImage(
        activity: activity, persona: activity.person.name);
    LoggerService.log(imageUrl.toString());
    Uri link = await generateActivityLink(
        activity: activity, mine: mine, imageUrl: imageUrl);
    return Share.share(link.toString());
  }
}
