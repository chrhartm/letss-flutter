import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:letss_app/backend/activityservice.dart';
import 'package:letss_app/backend/chatservice.dart';
import 'package:letss_app/backend/personservice.dart';
import 'package:letss_app/backend/templateservice.dart';
import 'package:letss_app/models/template.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/screens/activities/widgets/searchcard.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;

import '../models/person.dart';
import 'loggerservice.dart';
import '../models/activity.dart';

class LinkService {
  static final LinkService _me = LinkService._internal();
  LinkService._internal();
  static LinkService get instance => _me;

  static Uri _generateLink({required String link}) {
    String base = "https://letss.app";
    return Uri.parse(base + link);
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

  static Future<void> downloadAndShareImage(Activity activity) async {
    Uri? url =
        await generateImage(activity: activity, persona: activity.person.name);
    // First download file
    if (url == null) {
      return;
    }
    final response = await http.get(url);
    XFile tmpfile = XFile.fromData(response.bodyBytes,
        name: "activity.png", mimeType: "image/png");
    // Then share
    Share.shareXFiles([tmpfile])
        .onError((error, stackTrace) => LoggerService.log(error.toString()));
  }

  static Future<ShareResult> shareActivity(
      {required Activity activity, required bool mine}) async {
    Uri link = _generateLink(link: '/activity/${activity.uid}');
    return Share.share(link.toString());
  }

  static Future<ShareResult> shareProfile(
      {required Person person,
      required String title,
      required String description,
      required String prompt}) async {
    Uri link = _generateLink(
      link: '/profile/person/${person.uid}',
    );
    return Share.share("$prompt\n${link.toString()}");
  }

  void processLink(BuildContext context, Uri? link) async {
    LoggerService.log("Processing link: ${link.toString()}");
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
              context.mounted
                  ? Navigator.pushNamed(context, '/profile/person',
                      arguments: person)
                  : null);
        } catch (e) {
          LoggerService.log("Error in getting person from link");
        }
      } else if (secondSegment == "interests") {
        Navigator.pushNamed(context, '/profile/interests');
      } else {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        Provider.of<NavigationProvider>(context, listen: false)
            .navigateTo('/myprofile');
      }
    } else if (firstSegment == "activity") {
      Activity activity = await ActivityService.getActivity(secondSegment);
      if (activity.status == "ACTIVE") {
        context.mounted
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    settings: const RouteSettings(name: '/activities/activity'),
                    builder: (context) => SearchCard(activity)))
            : null;
      } else {
        LoggerService.log("This activity has been archived", level: "w");
      }
    } else if (firstSegment == "chat" || firstSegment == "chats") {
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Provider.of<NavigationProvider>(context, listen: false)
          .navigateTo('/chats');
      ChatService.getChat(chatId: secondSegment).then((chat) {
        context.mounted
            ? Navigator.pushNamed(context, "/chats/chat", arguments: chat)
            : null;
      }).onError((error, stackTrace) => null);
    } else if (firstSegment == "myactivity") {
      if (secondSegment == "from-template") {
        try {
          Template? template = await TemplateService.getTemplate(thirdSegment);
          if (template != null) {
            context.mounted
                ? Provider.of<MyActivitiesProvider>(context, listen: false)
                    .editActivityFromTemplate(context, template)
                : null;
          }
        } catch (e) {
          LoggerService.log("Error in getting template from link");
        }
      } else {
        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        Provider.of<NavigationProvider>(context, listen: false)
            .navigateTo('/myactivities');
      }
    } else if (firstSegment == "activities") {
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
      Provider.of<NavigationProvider>(context, listen: false)
          .navigateTo('/activities');
    } else if (firstSegment == "notification-settings") {
      AppSettings.openAppSettings(type: AppSettingsType.notification);
    } else if (firstSegment == "support") {
      context.mounted ? Navigator.pushNamed(context, '/support/pitch') : null;
    }
  }
}
