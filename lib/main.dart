import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letss_app/backend/cacheservice.dart';
import 'package:letss_app/backend/configservice.dart';
import 'package:letss_app/models/chat.dart';
import 'package:letss_app/provider/connectivityprovider.dart';
import 'package:letss_app/provider/followerprovider.dart';
import 'package:letss_app/screens/activities/search.dart';
import 'package:letss_app/screens/chats/chatscreen.dart';
import 'package:letss_app/screens/chats/profile.dart';
import 'package:letss_app/screens/myactivities/addfollowers.dart';
import 'package:letss_app/screens/myactivities/templates.dart';
import 'package:letss_app/screens/profile/follow.dart';
import 'package:letss_app/screens/signup/signupexplainer.dart';
import 'package:letss_app/screens/signup/signupnotifications.dart';
import 'package:letss_app/screens/support/supportpitch.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
import 'provider/routeprovider.dart';
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

// Add near top of file with other declarations
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded<Future<void>>(() async {
    WidgetsBinding wb =
        WidgetsFlutterBinding.ensureInitialized(); // From firebase init docs
    FlutterNativeSplash.preserve(widgetsBinding: wb);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate(
      webProvider:
          ReCaptchaV3Provider('6Lc2wNgpAAAAAJwoO2pMOXb9iN0BU4WhBxCWnmJf'),
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    );

    FirebaseMessaging.onBackgroundMessage(
        MessagingService.firebaseMessagingBackgroundHandler);
    await GenericConfigService.init();
    await LoggerService.init();
    // Only allow portrait orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FlutterNativeSplash.remove();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.grey[100]!,
    ));
    runApp(MyApp());
  },
      (error, stack) => kIsWeb
          ? LoggerService.log(error.toString())
          : FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Letss';
  static const googleApiKey = String.fromEnvironment('GOOGLE_API');

  @override
  Widget build(BuildContext context) {
    // load with --dart-define-from-file api-keys.json in vscode launch config
    assert(googleApiKey.isNotEmpty);

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
                ChangeNotifierProvider(create: (context) => RouteProvider()),
              ],
              child: OverlaySupport.global(
                  child: MaterialApp(
                navigatorKey: navigatorKey,
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
                navigatorObservers: [
                  RouteAwareObserver(),
                ],
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
                  '/signup/notifications': (context) => SignUpNotifications(),
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
  const LoginChecker({required this.context, super.key});

  final BuildContext context;

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

class _LoginCheckerState extends State<LoginChecker>
    with WidgetsBindingObserver {
  // User auth
  late UserProvider user;
  bool init = false;
  late AppLinks _appLinks;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FlutterLocalNotificationsPlugin().cancelAll();
      if (!kIsWeb && Platform.isIOS) {
        await FlutterAppBadger.removeBadge();
      }
    }
  }

  void processLink(final Uri link) async {
    bool email = false;
    try {
      email = await AuthService.verifyLink(
          link.toString(), user.user.email, context);
    } catch (e) {
      LoggerService.log("Error in verify Link");
    }
    if (mounted) {
      if (email ||
          !Provider.of<UserProvider>(context, listen: false).initialized) {
      } else {
        try {
          LinkService.instance.processLink(context, link);
        } catch (e) {
          LoggerService.log(e.toString());
          LoggerService.log("Could not process link", level: "i");
        }
      }
    }
  }

  void initDynamicLinks() async {
    if (kIsWeb) return; // not supported on web
    _appLinks.uriLinkStream.listen((uriValue) {
      processLink(uriValue);
    });

    final appLink = await _appLinks.getInitialLink();
    if (appLink != null) {
      processLink(appLink);
    }
  }

  void initUserChanges() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        if (mounted) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initUserChanges();
    if (!kIsWeb) {
      _appLinks = AppLinks();
      initDynamicLinks();
      StoreService().init();
      MessagingService().init(context);
    }
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
                    MessagingService.triggerTokenUpdate();
                    init = true;
                  }
                  if (!user.user.finishedSignupFlow) {
                    return SignUpFirstActivity();
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
            if (kIsWeb) {
              AuthService.emailPasswordAuth(
                  email: "testuser5@letss.app", password: "testuser5");
              return Container();
            }
            return Welcome();
          });
    });
  }
}

class RouteAwareObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _updateRouteProvider(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _updateRouteProvider(previousRoute);
    }
  }

  void _updateRouteProvider(Route<dynamic> route) {
    String? routeName = route.settings.name;
    if (routeName != null) {
      if (routeName == "/chats/chat") {
        String chatId = (route.settings.arguments as Chat).uid;
        routeName = "/chats/$chatId";
      }
      Provider.of<RouteProvider>(navigatorKey.currentContext!, listen: false)
          .updateRoute(routeName);
    }
  }
}
