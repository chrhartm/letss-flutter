import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:letss_app/backend/genericconfigservice.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/buttons/buttonprimary.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../backend/authservice.dart';

class Welcome extends StatelessWidget {
  Welcome({super.key});

  List<AnimatedText> _generateActivities(BuildContext context) {
    List<dynamic> activities =
        GenericConfigService.getJson("welcome_activities")["activities"];
    List<AnimatedText> acts = [];
    TextStyle style = Theme.of(context).textTheme.displayMedium!;
    for (int i = 0; i < activities.length; i++) {
      acts.add(TyperAnimatedText(activities[i], textStyle: style));
    }
    return acts;
  }

  // For Google sign-in:
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  Widget build(BuildContext context) {
    // in case user deleted
    context.loaderOverlay.hide();

    TextStyle textstyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: Theme.of(context).colorScheme.secondary);
    TextStyle linkstyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.secondary,
        decoration: TextDecoration.underline);

    List<Widget> buttons = [
      const SizedBox(height: 30),
      Expanded(
          child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: _generateActivities(context)))),
      const SizedBox(height: 30),
      // Social sign-in buttons
      Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  onSecondary: Color(0xFF1F1F1F),
                  secondaryContainer: Color(0xFFF2F2F2))),
          child: ButtonPrimary(
            text: "Sign in with Google",
            icon: Image.asset('assets/images/google.png', height: 24),
            padding: Platform.isIOS ? 16 : 8,
            onPressed: () async {
              try {
                final GoogleSignInAccount? googleUser =
                    await _googleSignIn.signIn();
                if (googleUser != null) {
                  final GoogleSignInAuthentication googleAuth =
                      await googleUser.authentication;
                  AuthService.googleAuth(
                      googleAuth.accessToken, googleAuth.idToken);
                } else {
                  LoggerService.log("Google SignIn failed", level: "w");
                }
              } catch (e) {
                LoggerService.log("Goolge SignIn with error $e", level: "w");
              }
            },
          ))
    ];
    if (Platform.isIOS) {
      buttons.add(SignInWithAppleButton(
        onPressed: () async {
          try {
            await AuthService.signInWithApple();
          } catch (e) {
            LoggerService.log("Apple SignIn with error $e", level: "w");
          }
        },
      ));
    }
    buttons.addAll([
      ButtonPrimary(
        icon: Text("✉️"),
        text: AppLocalizations.of(context)!.welcomeAction,
        padding: Platform.isIOS ? 16 : 8,
        secondary: true,
        onPressed: () {
          Navigator.pushNamed(context, '/signup/email');
        },
      ),
      const SizedBox(height: 10),
      Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.welcomeLegal1,
                style: textstyle,
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.welcomeLegal2,
                style: linkstyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(
                        GenericConfigService.config.getString('urlTnc')));
                  },
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.welcomeLegal3,
                style: textstyle,
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.welcomeLegal4,
                style: linkstyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(Uri.parse(
                        GenericConfigService.config.getString('urlPrivacy')));
                  },
              ),
              TextSpan(
                text: '.',
                style: textstyle,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 30)
    ]);
    return MyScaffold(
        body: Padding(
            padding: EdgeInsets.all(20.0), child: Column(children: buttons)));
  }
}
