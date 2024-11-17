import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'dart:isolate';

import 'package:overlay_support/overlay_support.dart';

class LoggerService {
  static Logger logger = Logger();

  static Future init() async {
    if (!kIsWeb) {
      if (kDebugMode) {
        // Force disable Crashlytics collection while doing every day development.
        // Temporarily toggle this to true if you want to test crash reporting in your app.
        await FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false);
      } else {
        // Handle Crashlytics enabled status when not in Debug,
        // e.g. allow your users to opt-in to crash reporting.
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseCrashlytics.instance
              .setUserIdentifier(FirebaseAuth.instance.currentUser!.uid);
        }
      }

      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
        );
      }).sendPort);
    }
  }

  static log(String message, {String level = 'd'}) {
    if (level == "e") {
      if (message.contains("offline")) {
        message = "You seem to be offline. Please try again later.";
      }
      showSimpleNotification(Text(message),
          background: Colors.grey[800], duration: Duration(seconds: 5));
    }
    if (kDebugMode) {
      if (level == 'w') {
        logger.w(message);
      }
      if (level == 'e') {
        logger.e(message);
      } else {
        logger.d(message);
      }
    } else {
      kIsWeb ? logger.d(message) : FirebaseCrashlytics.instance.log(message);
    }
  }

  static void setUserIdentifier(String uid) {
    if (kDebugMode || kIsWeb) {
    } else {
      FirebaseCrashlytics.instance.setUserIdentifier(uid);
    }
  }
}
