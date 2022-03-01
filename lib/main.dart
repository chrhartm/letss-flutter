import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letss_app/backend/cacheservice.dart';
import 'package:letss_app/screens/signup/signupexplainer.dart';
import 'package:letss_app/screens/support/supportpitch.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Other
import 'backend/StoreService.dart';
import 'theme/theme.dart';
import 'backend/messagingservice.dart';
import 'backend/analyticsservice.dart';
import 'backend/loggerservice.dart';
import 'backend/authservice.dart';
import 'backend/activityservice.dart';
import 'models/activity.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
// Provider
import 'provider/userprovider.dart';
import 'provider/activitiesprovider.dart';
import 'provider/myactivitiesprovider.dart';
import 'provider/chatsprovider.dart';
import 'provider/navigationprovider.dart';
import 'provider/notificationsprovider.dart';
// Screens
import 'screens/myactivities/activityscreen.dart';
import 'screens/myactivities/editactivitycategories.dart';
import 'screens/myactivities/editactivitydescription.dart';
import 'screens/myactivities/editactivityname.dart';
import 'screens/home.dart';
import 'screens/loading.dart';
import 'screens/profile/settings.dart';
import 'screens/signup/signupbio.dart';
import 'screens/signup/signupdob.dart';
import 'screens/signup/signupemail.dart';
import 'screens/signup/signupinterests.dart';
import 'screens/signup/signupjob.dart';
import 'screens/signup/signupgender.dart';
import 'screens/signup/signuplocation.dart';
import 'screens/signup/signupname.dart';
import 'screens/signup/signuppic.dart';
import 'screens/signup/signupwaitlink.dart';
import 'screens/signup/signupfirstactivity.dart';
import 'screens/signup/welcome.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized(); // From firebase init docs
    FirebaseMessaging.onBackgroundMessage(
        MessagingService.firebaseMessagingBackgroundHandler);
    await RemoteConfigService.init();
    await LoggerService.init();
    // Only allow portrait orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(MyApp());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
    ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Letss';

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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
                    create: (context) => NavigationProvider()),
                ChangeNotifierProvider(
                  create: (context) => NotificationsProvider(user),
                )
              ],
              child: OverlaySupport.global(
                  child: MaterialApp(
                debugShowCheckedModeBanner: false,
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
                  '/signup/gender': (context) => SignUpGender(),
                  '/signup/waitlink': (context) => SignUpWaitLink(),
                  '/signup/firstactivity': (context) => SignUpFirstActivity(),
                  '/signup/signupexplainer': (context) => SignUpExplainer(),
                  '/myactivities/activity/editname': (context) =>
                      EditActivityName(),
                  '/myactivities/activity/editdescription': (context) =>
                      EditActivityDescription(),
                  '/myactivities/activity/editcategories': (context) =>
                      EditActivityCategories(),
                  '/support/pitch': (context) => SupportPitch(),
                },
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
              )));
        }));
  }
}

class LoginChecker extends StatefulWidget {
  const LoginChecker({Key? key}) : super(key: key);

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

class _LoginCheckerState extends State<LoginChecker>
    with WidgetsBindingObserver {
  // User auth
  late UserProvider user;
  bool init = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FlutterLocalNotificationsPlugin().cancelAll();
    }
  }

  void processLink(final Uri deepLink) async {
    bool email = false;
    try {
      email = await AuthService.verifyLink(
          deepLink.toString(), user.user.email, context);
    } catch (e) {
      LoggerService.log("Error in verify Link");
    }

    if (email) {
    } else {
      try {
        LoggerService.log(deepLink.pathSegments.toString());
        String firstSegment = deepLink.pathSegments[0];
        String secondSegment = "";
        if (deepLink.pathSegments.length > 1) {
          secondSegment = deepLink.pathSegments[1];
        }

        if (firstSegment == "activity") {
          Activity activity = await ActivityService.getActivity(secondSegment);
          if (activity.status == "ACTIVE") {
            if (activity.person.uid != FirebaseAuth.instance.currentUser!.uid) {
              Provider.of<ActivitiesProvider>(context, listen: false)
                  .addTop(activity);

              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
              Provider.of<NavigationProvider>(context, listen: false)
                  .navigateTo('/activities');
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      settings:
                          const RouteSettings(name: '/myactivities/activity'),
                      builder: (context) =>
                          ActivityScreen(activity: activity)));
            }
          } else {
            LoggerService.log("This activity has been archived", level: "e");
          }
        } else if (firstSegment == "chat") {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          Provider.of<NavigationProvider>(context, listen: false)
              .navigateTo('/chats');
        } else if (firstSegment == "myactivity") {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          Provider.of<NavigationProvider>(context, listen: false)
              .navigateTo('/myactivities');
        }
      } catch (e) {
        LoggerService.log(e.toString());
        LoggerService.log("Could not process link", level: "e");
      }
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen(
        (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      if (deepLink != null) {
        processLink(deepLink);
      }
    }, onError: (e) async {
      LoggerService.log('Error logging in, please restart app.', level: "e");
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
    StoreService().init();
    MessagingService().init();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    StoreService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (_, snapshot) {
            // These providers only for init and clear
            NotificationsProvider notifications =
                Provider.of<NotificationsProvider>(context, listen: false);
            ChatsProvider chats =
                Provider.of<ChatsProvider>(context, listen: false);
            NavigationProvider nav =
                Provider.of<NavigationProvider>(context, listen: false);
            MyActivitiesProvider myActivities =
                Provider.of<MyActivitiesProvider>(context, listen: false);
            ActivitiesProvider activities =
                Provider.of<ActivitiesProvider>(context, listen: false);
            this.user = user;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.data is User && snapshot.data != null) {
              user.loadUser();
              if (!user.initialized) {
                return Loading();
              }
              if (user.completedSignup()) {
                if (!init) {
                  activities.init();
                  chats.init();
                  nav.init();
                  myActivities.init();
                  notifications.init();
                  // After first grant or reject, this won't show dialogs
                  MessagingService.requestPermissions();
                  init = true;
                }
                if (!user.user.finishedSignupFlow) {
                  if (RemoteConfigService.remoteConfig
                      .getBool("forceAddActivity")) {
                    return SignUpFirstActivity();
                  } else {
                    return SignUpExplainer();
                  }
                }

                analytics.setCurrentScreen(screenName: "/activities");
                return Home();
              }
              analytics.setCurrentScreen(screenName: "/signup/name");
              // Assumption: We only get here at first signup, therefore ok to
              // set requestedActivity to false
              user.user.finishedSignupFlow = false;
              return SignUpName();
            } else {
              // Assume logout, deletion, clearing, ...
              if (init) {
                user.clearData();
                activities.clearData();
                myActivities.clearData();
                chats.clearData();
                nav.clearData();
                notifications.clearData();
                CacheService.clearData();
                init = false;
              }
              analytics.setCurrentScreen(screenName: "/welcome");
              return Welcome();
            }
          });
    });
  }
}
