import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../backend/loggerservice.dart';

class AuthService {
  static void emailAuth(String email) {
    var acs = ActionCodeSettings(
        url: 'https://letss.app/applink',
        handleCodeInApp: true,
        androidPackageName: 'com.letss.letssapp',
        dynamicLinkDomain: 'letssapp.page.link',
        // installIfNotAvailable
        androidInstallApp: true,
        iOSBundleId: 'com.letss.letssapp');

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError((onError) => LoggerService.log(
            'Couldn\'t send email. Please try again later.',
            level: "w"));
  }

  static void emailPasswordAuth(
      {required String email, required String password}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) => LoggerService.log(
            "Couldn't sign in $email with password: $password",
            level: "e"));
  }

  static void googleAuth(String? accessToken, String? idToken) {
    final creds = GoogleAuthProvider.credential(
        accessToken: accessToken, idToken: idToken);
    LoggerService.log("Signing in with Google creds $creds", level: "i");
    FirebaseAuth.instance.signInWithCredential(creds).catchError((e) =>
        LoggerService.log("Couldn't sign in with creds $creds", level: "e"));
  }

  static signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  static Future<bool> verifyLink(
      String link, String? email, BuildContext context) async {
    var auth = FirebaseAuth.instance;

    if (auth.isSignInWithEmailLink(link)) {
      if (email == null) {
        LoggerService.log("Please provide your email again", level: "w");
        return false;
      }
      try {
        await auth.signInWithEmailLink(email: email, emailLink: link);
        return true;
      } catch (error) {
        LoggerService.log(getMessageFromErrorCode(error), level: "w");
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
