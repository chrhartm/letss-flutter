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
      LoggerService.log("Please provide your email again", context: context);
      return false;
    }
    LoggerService.log("in link verify", context: context);
    var auth = FirebaseAuth.instance;
    if (auth.isSignInWithEmailLink(link)) {
      LoggerService.log("after check", context: context);
      LoggerService.log(email, context: context);
      auth.signInWithEmailLink(email: email, emailLink: link).then((value) {
        LoggerService.log('Successfully signed in with email link!',
            context: context);
        return true;
      }).catchError((onError) {
        LoggerService.log('Error signing in with email link $onError',
            level: "e", context: context);
      });
    }
    return false;
  }
}
