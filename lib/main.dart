import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letss_app/backend/cacheservice.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/provider/connectivityprovider.dart';
import 'package:letss_app/provider/followerprovider.dart';
import 'package:letss_app/screens/activities/search.dart';
import 'package:letss_app/screens/chats/chatscreen.dart';
import 'package:letss_app/screens/chats/profile.dart';
import 'package:letss_app/screens/myactivities/addfollowers.dart';
import 'package:letss_app/screens/myactivities/templates.dart';
import 'package:letss_app/screens/profile/follow.dart';
import 'package:letss_app/screens/signup/signupexplainer.dart';
import 'package:letss_app/screens/support/supportpitch.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

// Other
import 'backend/StoreService.dart';
import 'backend/linkservice.dart';
import 'screens/signup/travel.dart';
import 'theme/theme.dart';
import 'backend/messagingservice.dart';
import 'backend/loggerservice.dart';
import 'backend/authservice.dart';
import 'package:letss_app/backend/genericconfigservice.dart';
// Provider
import 'provider/userprovider.dart';
import 'provider/activitiesprovider.dart';
import 'provider/myactivitiesprovider.dart';
import 'provider/chatsprovider.dart';
import 'provider/navigationprovider.dart';
import 'provider/notificationsprovider.dart';
// Screens
import 'screens/myactivities/editactivitycategories.dart';
import 'screens/myactivities/editactivitydescription.dart';
import 'screens/myactivities/editactivityname.dart';
import 'screens/home.dart';
import 'screens/loading.dart';
import 'screens/profile/settings.dart';
import 'screens/signup/signupbio.dart';
import 'screens/signup/signupage.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    // TODO better error handling
    print(details.exceptionAsString());
    FlutterError.presentError(details);
  };
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // TODO debug
    await Upgrader.clearSavedSettings(); // REMOVE this for release builds

    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      // Set androidProvider to `AndroidProvider.debug`
      androidProvider: AndroidProvider.playIntegrity,
    );
    WidgetsFlutterBinding.ensureInitialized(); // From firebase init docs
    FirebaseMessaging.onBackgroundMessage(
        MessagingService.firebaseMessagingBackgroundHandler);
    await GenericConfigService.init();
    await LoggerService.init();
    // Only allow portrait orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await dotenv.load(fileName: ".env");
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
                    create: (context) => NotificationsProvider(user)),
                ChangeNotifierProvider(create: (context) => FollowerProvider()),
                ChangeNotifierProvider(
                    create: (context) => ConnectivityProvider()),
              ],
              child: OverlaySupport.global(
                  child: MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: // [Locale("de")], // debug
                    AppLocalizations.supportedLocales,
                title: _title,
                theme: apptheme,
                routes: {
                  '/': (context) => LoginChecker(context: context),
                  '/profile/settings': (context) => Settings(),
                  '/signup/email': (context) => SignUpEmail(),
                  '/signup/name': (context) => SignUpName(),
                  '/profile/name': (context) => SignUpName(signup: false),
                  '/signup/age': (context) => SignUpAge(),
                  '/profile/age': (context) => SignUpAge(signup: false),
                  '/signup/location': (context) => SignUpLocation(),
                  '/profile/location': (context) =>
                      SignUpLocation(signup: false),
                  '/profile/location/travel': (context) => Travel(),
                  '/signup/pic': (context) => SignUpPic(),
                  '/profile/pic': (context) => SignUpPic(
                        signup: false,
                      ),
                  '/signup/bio': (context) => SignUpBio(),
                  '/profile/bio': (context) => SignUpBio(signup: false),
                  '/signup/interests': (context) => SignUpInterests(),
                  '/profile/interests': (context) =>
                      SignUpInterests(signup: false),
                  '/signup/job': (context) => SignUpJob(),
                  '/profile/job': (context) => SignUpJob(signup: false),
                  '/signup/gender': (context) => SignUpGender(),
                  '/profile/gender': (context) => SignUpGender(signup: false),
                  '/signup/waitlink': (context) => SignUpWaitLink(),
                  '/signup/firstactivity': (context) => SignUpFirstActivity(),
                  '/signup/signupexplainer': (context) => SignUpExplainer(),
                  '/activities/search': (context) => Search(),
                  '/myactivities/activity/editname': (context) =>
                      EditActivityName(),
                  '/myactivities/activity/editdescription': (context) =>
                      EditActivityDescription(),
                  '/myactivities/activity/editcategories': (context) =>
                      EditActivityCategories(),
                  '/myactivities/templates': (context) => Templates(),
                  '/myactivities/addfollowers': (context) => AddFollowers(),
                  '/support/pitch': (context) => SupportPitch(),
                  '/chats/chat': (context) => ChatScreen(),
                  '/profile/person': (context) => Profile(),
                  '/profile/following': (context) => Follow(following: true),
                  '/profile/followers': (context) => Follow(following: false),
                },
              )));
        }));
  }
}

class LoginChecker extends StatefulWidget {
  const LoginChecker({required this.context, Key? key}) : super(key: key);

  final BuildContext context;

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
      if (Platform.isIOS) {
        await FlutterAppBadger.removeBadge();
      }
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

    if (email ||
        !Provider.of<UserProvider>(widget.context, listen: false).initialized) {
    } else {
      try {
        LinkService().processLink(context, deepLink);
      } catch (e) {
        LoggerService.log(e.toString());
        LoggerService.log("Could not process link", level: "i");
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
      LoggerService.log('Error logging in, please restart app.', level: "w");
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
    MessagingService().init(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
            FollowerProvider followers =
                Provider.of<FollowerProvider>(context, listen: false);
            this.user = user;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.data is User && snapshot.data != null) {
              user.loadUser(context);
              if (!user.initialized) {
                return Loading();
              }
              if (user.user.status == "ACTIVE") {
                if (user.completedSignup()) {
                  if (!init) {
                    activities.init();
                    chats.init();
                    followers.init();
                    nav.init();
                    myActivities.init();
                    notifications.init();
                    init = true;
                  }
                  if (!user.user.finishedSignupFlow) {
                    if (ConfigService.config.forceAddActivity) {
                      return SignUpFirstActivity();
                    }
                  }

                  return Home();
                }
                // Assumption: We only get here at first signup, therefore ok to
                // set requestedActivity to false
                user.user.finishedSignupFlow = false;
                return SignUpName();
              }
            }
            // Assume logout, deletion, clearing, ...
            if (init || user.user.status != "ACTIVE") {
              user.clearData();
              activities.clearData();
              myActivities.clearData();
              chats.clearData();
              followers.clearData();
              nav.clearData();
              notifications.clearData();
              CacheService.clearData();
              ConfigService.reset();
              init = false;
            }
            return Welcome();
          });
    });
  }
}
