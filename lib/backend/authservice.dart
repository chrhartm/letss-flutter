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
        .catchError(
            (onError) => logger.e('Error sending email verification $onError'))
        .then((value) => logger.i('Successfully sent email verification'));
  }

  static bool verifyLink(String link, String? email) {
    if (email == null) {
      return false;
    }
    var auth = FirebaseAuth.instance;
    if (auth.isSignInWithEmailLink(link)) {
      logger.d("after check");
      logger.d(email);
      auth.signInWithEmailLink(email: email, emailLink: link).then((value) {
        logger.i('Successfully signed in with email link!');
        return true;
      }).catchError((onError) {
        logger.e('Error signing in with email link $onError');
      });
    }
    return false;
  }
}
