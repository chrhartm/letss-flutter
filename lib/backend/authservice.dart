import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../backend/loggerservice.dart';

class AuthService {
  static void emailAuth(String email) {
    var acs = ActionCodeSettings(
        url: 'https://letss.app/verifyemail',
        handleCodeInApp: true,
        androidPackageName: 'com.letss.letssapp',
        dynamicLinkDomain: 'letss.page.link',
        // installIfNotAvailable
        androidInstallApp: true,
        iOSBundleId: 'com.letss.letssapp');

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError((onError) => LoggerService.log(
            'Error sending email verification $onError',
            level: "e"));
  }

  static Future<bool> verifyLink(
      String link, String? email, BuildContext context) async {
    if (email == null) {
      LoggerService.log("Please provide your email again", level: "e");
      return false;
    }
    var auth = FirebaseAuth.instance;
    if (auth.isSignInWithEmailLink(link)) {
      try {
        await auth.signInWithEmailLink(email: email, emailLink: link);
        return true;
      } catch (error) {
        LoggerService.log(getMessageFromErrorCode(error), level: "e");
        return false;
      }
    }
    return false;
  }

  static String getMessageFromErrorCode(Object error) {
    try {
      return error
          .toString()
          .replaceRange(0, 14, '')
          .split(']')[1]
          .replaceRange(0, 1, '');
    } catch (e) {
      return error.toString();
    }
  }
}
