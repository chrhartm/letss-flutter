import 'package:flutter/material.dart';
import '../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../backend/authservice.dart';

class SignUpWaitLink extends StatelessWidget {
  String? link;

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
          child: Text(
              'Open the link in the email on the same device to continue.'),
          back: false,
        ),
      ));
    });
  }
}
