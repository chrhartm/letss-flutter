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
import 'backend/authservice.dart';
import 'backend/activityservice.dart';
import 'models/activity.dart';
// Provider
import 'provider/userprovider.dart';
import 'provider/activitiesprovider.dart';
import 'provider/myactivitiesprovider.dart';
import 'provider/chatsprovider.dart';
import 'provider/notificationsprovider.dart';
// Screens
import 'screens/activityscreen.dart';
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
      MessagingService().firebaseMessagingBackgroundHandler);
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return Loading();
      },
    );
  }
}

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
                    create: (context) => ActivitiesProvider(user)),
                ChangeNotifierProvider(
                    create: (context) => MyActivitiesProvider(user)),
                ChangeNotifierProvider(create: (context) => ChatsProvider()),
                ChangeNotifierProvider(
                  create: (context) => NotificationsProvider(user),
                )
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
  late UserProvider user;
  late ActivitiesProvider actProv;

  void processLink(final Uri deepLink) async {
    logger.i(deepLink);

    if (AuthService.verifyLink(deepLink.toString(), user.user.email)) {
      user.loadPerson();
    } else {
      try {
        logger.d(deepLink.pathSegments);
        if (deepLink.pathSegments[0] == "activity") {
          Activity activity =
              await ActivityService.getActivity(deepLink.pathSegments[1]);
          if (activity.status == "ACTIVE") {
            if (activity.person.uid != FirebaseAuth.instance.currentUser!.uid) {
              actProv.add(activity);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings:
                          const RouteSettings(name: '/myactivities/activity'),
                      builder: (context) =>
                          ActivityScreen(activity: activity)));
            }
          }
        }
      } catch (e) {
        logger.w("Could not process link");
      }
    }
  }

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
      if (user != null) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.initDynamicLinks();
    this.initUserChanges();
    MessagingService().init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Consumer<ActivitiesProvider>(
          builder: (context, activities, child) {
        return StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (_, snapshot) {
              this.user = user;
              this.actProv = activities;
              if (snapshot.connectionState == ConnectionState.waiting ||
                  (snapshot.data is User &&
                      snapshot.data != null &&
                      !user.initialized)) {
                return Loading();
              }
              if (snapshot.data is User &&
                  snapshot.data != null &&
                  user.initialized) {
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
      });
    });
  }
}
