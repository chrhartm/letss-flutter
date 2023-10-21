import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/screens/activities/widgets/searchcard.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

import '../models/person.dart';
import '../screens/myactivities/activityscreen.dart';
import 'loggerservice.dart';
import '../models/activity.dart';

class LinkService {
  static final LinkService _me = LinkService._internal();

  LinkService._internal();

  factory LinkService() {
    return _me;
  }

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

    final ShortDynamicLink shortDynamicLink = await FirebaseDynamicLinks
        .instance
        .buildShortLink(parameters)
        .onError((error, stackTrace) => LoggerService.log(error.toString()));
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

  void processLink(BuildContext context, Uri? link) async {
    if (link == null) {
      return;
    }
    LoggerService.log("Processing link: ${link.toString()}");
    LoggerService.log(link.pathSegments.toString());
    String firstSegment = link.pathSegments[0];
    String secondSegment = "";
    String thirdSegment = "";
    if (link.pathSegments.length > 1) {
      secondSegment = link.pathSegments[1];
      if (link.pathSegments.length > 2) {
        thirdSegment = link.pathSegments[2];
      }
    }
    if (firstSegment == "profile") {
      if (secondSegment == "person") {
        String personId = thirdSegment;
        try {
          PersonService.getPerson(uid: personId).then((person) =>
              Navigator.pushNamed(context, '/profile/person',
                  arguments: person));
        } catch (e) {
          LoggerService.log("Error in getting person from link");
        }
      }
    } else if (firstSegment == "activity") {
      Activity activity = await ActivityService.getActivity(secondSegment);
      if (activity.status == "ACTIVE") {
        if (activity.person.uid != FirebaseAuth.instance.currentUser!.uid) {
          /*
          Provider.of<ActivitiesProvider>(context, listen: false)
              .addTop(activity);
ß
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          Provider.of<NavigationProvider>(context, listen: false)
              .navigateTo('/activities');
          */
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: '/activities/activity'),
                  builder: (context) => SearchCard(activity)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  settings: const RouteSettings(name: '/myactivities/activity'),
                  builder: (context) => ActivityScreen(activity: activity)));
        }
      } else {
        LoggerService.log("This activity has been archived", level: "w");
      }
    } else if (firstSegment == "chat" || firstSegment == "chats") {
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Provider.of<NavigationProvider>(context, listen: false)
          .navigateTo('/chats');
    } else if (firstSegment == "myactivity") {
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Provider.of<NavigationProvider>(context, listen: false)
          .navigateTo('/myactivities');
    }
  }
}
