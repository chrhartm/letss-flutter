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
        androidInstallApp: true);

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError((onError) => LoggerService.log(
            'Error sending email verification $onError',
            level: "e"));
  }

  static bool verifyLink(String link, String? email, BuildContext context) {
    if (email == null) {
      LoggerService.log("Please provide your email again", level: "e");
      return false;
    }
    var auth = FirebaseAuth.instance;
    if (auth.isSignInWithEmailLink(link)) {
      auth.signInWithEmailLink(email: email, emailLink: link).then((value) {
        return true;
      }).catchError((onError) {
        LoggerService.log('Error signing in with email link $onError',
            level: "e");
      });
    }
    return false;
  }
}
