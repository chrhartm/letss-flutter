import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/signup.dart';
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
    return MaterialApp(
        title: _title,
        theme: apptheme,
        home: ChangeNotifierProvider(
          create: (context) => UserProvider(),
          child: LoginChecker(),
        ));
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

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        _signedIn = false;
      } else {
        _signedIn = true;
      }
    });
    if (_signedIn) {
      return Home();
    } else {
      return Home();
      //TODO return SignUp();
    }
  }
}
