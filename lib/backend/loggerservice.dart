import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:isolate';

class LoggerService {
  static Logger logger = Logger();

  static Future init() async {
    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      // TODO do I need opt-in crash reporting?
      // Handle Crashlytics enabled status when not in Debug,
      // e.g. allow your users to opt-in to crash reporting.
    }

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);
  }

  static log(dynamic message, {String level = 'd', BuildContext? context}) {
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
      final snackBar = SnackBar(content: Text(message));

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        FirebaseCrashlytics.instance.log(message);
      }
    }
  }

  // TODO use this
  static void setUserIdentifier(String uid) {
    if (kDebugMode) {
    } else {
      FirebaseCrashlytics.instance.setUserIdentifier(uid);
    }
  }
}
