import 'package:flutter/material.dart';
import '../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../widgets/subtitleheaderscreen.dart';
import '../backend/authservice.dart';

class SignUpWaitLink extends StatelessWidget {
  String? link;

  SignUpWaitLink({this.link}) {
    // TODO replace with open on app opening
    //this.link =
    //    'https://letss.page.link/?link=https://letss-11cc7.firebaseapp.com/__/auth/action?apiKey%3DAIzaSyCW2NGi3lLK7u85bx6LTRau_VhNZRpTuGA%26mode%3DsignIn%26oobCode%3DPONPLQQ2gorGFU1Y39hXxEDN1OVZ0Gz1w8J9PCAdPO4AAAF7byEkaw%26continueUrl%3Dhttps://letss.app/verifyemail%26lang%3Den&apn=com.letss.letssapp&amv';
  }

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
