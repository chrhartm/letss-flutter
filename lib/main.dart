import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:letss_app/screens/signupname.dart';
import 'package:provider/provider.dart';
import 'screens/welcome.dart';
import 'screens/loading.dart';
import 'screens/home.dart';
import 'theme/theme.dart';
import 'provider/userprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // From firebase init docs
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
              child: MaterialApp(title: _title, theme: apptheme, routes: {
                '/': (context) => LoginChecker(),
                '/welcome': (context) => Welcome(),
                '/home': (context) => Home()
              }));
        }));
  }
}

/// This is the stateful widget that the main application instantiates.
class LoginChecker extends StatefulWidget {
  const LoginChecker({Key? key}) : super(key: key);

  @override
  State<LoginChecker> createState() => _LoginCheckerState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _LoginCheckerState extends State<LoginChecker> {
  // User auth
  bool _signedIn = false;

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (this._signedIn) {
        if (user.completedSignup()) {
          return Home();
        }
        return SignUpName();
      }
      return Welcome();
    });
  }
}
