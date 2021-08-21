import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static void emailAuth(String email) {
    var acs = ActionCodeSettings(
        url: 'https://letss.app/finishsignup',
        handleCodeInApp: true,
        androidPackageName: 'com.letss.letssapp',
        // installIfNotAvailable
        androidInstallApp: true);

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));
  }
}
