import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

import 'loggerservice.dart';
import '../models/activity.dart';

class LinkService {
  static Future<Uri> generateActivityLink(
      {required Activity activity, required bool mine}) async {
    String uid = activity.uid;
    Uri fallbackUrl = Uri.parse('https://letss.app/activity');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://letssapp.page.link',
      link: Uri.parse('https://letss.app/activity/$uid'),
      androidParameters: AndroidParameters(
        packageName: 'com.letss.letssapp',
        minimumVersion: 1,
        fallbackUrl: fallbackUrl,
      ),
      iosParameters: IosParameters(
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
        title: mine ? "Join me on Letss" : "I found this activity on Letss",
        description: activity.name,
      ),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    LoggerService.log(
        "Sharing the URL:" + shortDynamicLink.shortUrl.toString());
    return shortDynamicLink.shortUrl;
  }

  static void shareActivity(
      {required Activity activity, required bool mine}) async {
    Uri link = await generateActivityLink(activity: activity, mine: mine);
    Share.share(activity.name + "\n" + link.toString());
  }
}
