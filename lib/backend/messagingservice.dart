import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:letss_app/backend/userservice.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../backend/loggerservice.dart';
import '../provider/routeprovider.dart';

class MessagingService {
  static final MessagingService _me = MessagingService._internal();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  MessagingService._internal();

  factory MessagingService() {
    return _me;
  }

  static Future<bool> openNotificationSettings() {
    return openAppSettings();
  }

  static Future<bool> notificationsEnabled() {
    return FirebaseMessaging.instance
        .getNotificationSettings()
        .then((settings) {
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    });
  }

  static Future<bool> notificationsDenied() {
    return FirebaseMessaging.instance
        .getNotificationSettings()
        .then((settings) {
      return settings.authorizationStatus == AuthorizationStatus.denied;
    });
  }

  static Future<void> requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
            sound: true,
            badge: true,
            alert: true,
            provisional: false,
            carPlay: false,
            criticalAlert: false,
            announcement: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      LoggerService.log('User granted provisional permission');
    } else {
      // Navigate to systems setting
      openNotificationSettings();
      LoggerService.log('User declined or has not accepted permission');
    }
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    LoggerService.log("Message received: ${message.toString()}");
    if (message.data.containsKey("link")) {
      String rawLink = message.data["link"];
      // Generate URI from rawlink
      Uri link = Uri.parse(rawLink);
      LinkService.instance.processLink(context, link);
    }
  }

  void init(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.containsKey("link") && context.mounted) {
        String rawLink = message.data["link"];
        String link = Uri.parse(rawLink).path;
        String currentRoute =
            Provider.of<RouteProvider>(context, listen: false).currentRoute;
        currentRoute = currentRoute.replaceAll("chats", "chat");

        if (currentRoute != "/" && link.startsWith(currentRoute)) {
          return;
        }
        if (currentRoute == "/chat" && link.startsWith("/chats/")) {
          return;
        }
      }

      if (message.notification != null && context.mounted) {
        // Show in-app notification
        showTopSnackBar(context, message);
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && context.mounted) {
        _handleMessage(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (context.mounted) {
        _handleMessage(context, message);
      }
    });

    triggerTokenUpdate();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateToken(newToken);
    });
  }

  static void triggerTokenUpdate() {
    FirebaseMessaging.instance.getToken().then((token) {
      if (token == null) {
        LoggerService.log("no fcm token", level: "w");
      } else {
        updateToken(token);
      }
    }).onError((error, stackTrace) =>
        LoggerService.log("Error getting token ${error.toString()}"));
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    // if platform is iOS, then increase badge count
    if (!kIsWeb && Platform.isIOS) {
      FlutterAppBadger.updateBadgeCount(1);
    }
    LoggerService.log("Handling a background message: ${message.messageId}");
  }

  static void updateToken(String token) {
    if (FirebaseAuth.instance.currentUser == null) {
      LoggerService.log("No user logged in when updating token", level: "w");
      return;
    }
    LoggerService.log(
        "Updating token for user ${FirebaseAuth.instance.currentUser!.uid}");
    UserService.updateToken(token);
  }

  void showTopSnackBar(BuildContext context, RemoteMessage message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 10 + MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.up,
          onDismissed: (_) {
            overlayEntry.remove();
          },
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: AnimationController(
                vsync: Navigator.of(context),
                duration: const Duration(milliseconds: 300),
              )..forward(),
              curve: Curves.easeOut,
            )),
            child: Material(
              elevation: 6.0,
              borderRadius: BorderRadius.circular(16.0),
              color: Theme.of(context).colorScheme.primary,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  overlayEntry.remove();
                  _handleMessage(context, message);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.notification!.title ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(message.notification!.body ?? '',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 3 seconds if not tapped
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
