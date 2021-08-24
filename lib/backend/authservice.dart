import 'package:firebase_auth/firebase_auth.dart';

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
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }

  static void verifyLink(String link, String email) {
    var auth = FirebaseAuth.instance;
    if (auth.isSignInWithEmailLink(link)) {
      auth.signInWithEmailLink(email: email, emailLink: link).then((value) {
        // You can access the new user via value.user
        // Additional user info profile *not* available via:
        // value.additionalUserInfo.profile == null
        // You can check if the user is new or existing:
        // value.additionalUserInfo.isNewUser;
        print('Successfully signed in with email link!');
      }).catchError((onError) {
        print('Error signing in with email link $onError');
      });
    }
  }
}
