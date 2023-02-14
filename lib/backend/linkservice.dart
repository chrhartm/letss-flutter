import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import 'loggerservice.dart';
import '../models/activity.dart';

class LinkService {
  static Future<Uri> generateActivityLink(
      {required Activity activity, required bool mine}) async {
    String uid = activity.uid;
    String activityTags =
        activity.categories.map((e) => "#" + e.name).join(", ");
    if (activityTags.length > 0) {
      activityTags = activityTags + ", ";
    }
    activityTags = activityTags + "#" + activity.locationString.toLowerCase();

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
          title: activity.name, description: activityTags),
    );

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    LoggerService.log(
        "Sharing the URL:" + shortDynamicLink.shortUrl.toString());
    return shortDynamicLink.shortUrl;
  }

  static Future<void> shareActivity(
      {required Activity activity, required bool mine}) async {
    Uri link = await generateActivityLink(activity: activity, mine: mine);
    return Share.share(link.toString());
  }
}
