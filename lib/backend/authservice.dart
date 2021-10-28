import 'package:firebase_auth/firebase_auth.dart';

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
            level: "e"))
        .then((value) =>
            LoggerService.log('Successfully sent email verification'));
  }

  static bool verifyLink(String link, String? email) {
    if (email == null) {
      return false;
    }
    var auth = FirebaseAuth.instance;
    if (auth.isSignInWithEmailLink(link)) {
      LoggerService.log("after check");
      LoggerService.log(email);
      auth.signInWithEmailLink(email: email, emailLink: link).then((value) {
        LoggerService.log('Successfully signed in with email link!');
        return true;
      }).catchError((onError) {
        LoggerService.log('Error signing in with email link $onError',
            level: "e");
      });
    }
    return false;
  }
}
