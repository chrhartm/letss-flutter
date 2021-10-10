import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Other
import 'theme/theme.dart';
import 'backend/messagingservice.dart';
import 'backend/analyticsservice.dart';
import 'backend/loggerservice.dart';
// Provider
import 'provider/userprovider.dart';
import 'provider/activitiesprovider.dart';
import 'provider/myactivitiesprovider.dart';
// Screens
import 'screens/editactivitycategories.dart';
import 'screens/editactivitydescription.dart';
import 'screens/editactivityname.dart';
import 'screens/home.dart';
import 'screens/loading.dart';
import 'screens/settings.dart';
import 'screens/signupbio.dart';
import 'screens/signupdob.dart';
import 'screens/signupemail.dart';
import 'screens/signupinterests.dart';
import 'screens/signupjob.dart';
import 'screens/signuplocation.dart';
import 'screens/signupname.dart';
import 'screens/signuppic.dart';
import 'screens/signupwaitlink.dart';
import 'screens/welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // From firebase init docs
  FirebaseMessaging.onBackgroundMessage(
      MessagingService.firebaseMessagingBackgroundHandler);
  runApp(App());
}

// From firebase init docs
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Loading();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Letss';

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();

    return ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: Consumer<UserProvider>(builder: (context, user, child) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (context) => ActivitiesProvider()),
                ChangeNotifierProvider(
                    create: (context) => MyActivitiesProvider(user))
              ],
              child: MaterialApp(
                title: _title,
                theme: apptheme,
                routes: {
                  '/': (context) => LoginChecker(),
                  '/profile/settings': (context) => Settings(),
                  '/signup/email': (context) => SignUpEmail(),
                  '/signup/name': (context) => SignUpName(),
                  '/signup/dob': (context) => SignUpDob(),
                  '/signup/location': (context) => SignUpLocation(),
                  '/signup/pic': (context) => SignUpPic(),
                  '/signup/bio': (context) => SignUpBio(),
                  '/signup/interests': (context) => SignUpInterests(),
                  '/signup/job': (context) => SignUpJob(),
                  '/signup/waitlink': (context) => SignUpWaitLink(),
                  '/myactivities/activity/editname': (context) =>
                      EditActivityName(),
                  '/myactivities/activity/editdescription': (context) =>
                      EditActivityDescription(),
                  '/myactivities/activity/editcategories': (context) =>
                      EditActivityCategories(),
                },
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
              ));
        }));
  }
}

class LoginChecker extends StatefulWidget {
  const LoginChecker({Key? key}) : super(key: key);

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

class _LoginCheckerState extends State<LoginChecker> {
  // User auth
  bool _signedIn = false;
  late UserProvider user;

  void processLink(final Uri deepLink) async {
    var auth = FirebaseAuth.instance;

    if (auth.isSignInWithEmailLink(deepLink.toString()) &&
        user.user.email != null) {
      // The client SDK will parse the code from the link for you.
      auth
          .signInWithEmailLink(
              email: user.user.email!, emailLink: deepLink.toString())
          .then((value) {
        logger.i('Successfully signed in with email link!');
        user.loadPerson();
      }).catchError((onError) {
        logger.e('Error signing in with email link $onError');
      });

      logger.i(deepLink);

      Navigator.pushNamed(context, deepLink.path);
    }
  }

  // TODO duplicated with authservice?
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        processLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      logger.e('onLinkError');
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      processLink(deepLink);
    }
  }

  void initUserChanges() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _signedIn = false;
        });
      } else {
        setState(() {
          _signedIn = true;
          Navigator.popUntil(context, ModalRoute.withName('/'));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
    this.initUserChanges();
    MessagingService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      this.user = user;
      if (this._signedIn && user.initialized) {
        if (user.completedSignup()) {
          analytics.setCurrentScreen(screenName: "/activities");
          return Home();
        }
        analytics.setCurrentScreen(screenName: "/signup/name");
        return SignUpName();
      }
      analytics.setCurrentScreen(screenName: "/welcome");
      return Welcome();
    });
  }
}
