import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/backend/authservice.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';

class SignUpWaitLink extends StatelessWidget {
  final String? link;

  SignUpWaitLink({this.link});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (this.link != null && user.user.email != null) {
        AuthService.verifyLink(this.link!, user.user.email!);
      }
      return Scaffold(
          body: SafeArea(
              child: SubTitleHeaderScreen(
                  title: 'Email sent ✉️',
                  subtitle: 'Click the link in your email to continue',
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                              'Open the link in the email on the same device to log in.',
                              style: Theme.of(context).textTheme.headline3),
                        ),
                        const SizedBox(height: 30),
                        ButtonPrimary(
                            text: "Open E-Mail",
                            onPressed: () {
                              launch("mailto://").catchError((e) {
                                ;
                              });
                            })
                      ]))));
    });
  }
}
