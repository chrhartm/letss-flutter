import 'package:flutter/material.dart';
import 'package:letss_app/backend/remoteconfigservice.dart';
import 'package:letss_app/screens/profile/widgets/deleteuserdialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/buttons/buttonlight.dart';
import '../widgets/tiles/textheaderscreen.dart';
import '../../provider/userprovider.dart';
import '../../backend/loggerservice.dart';

class Settings extends StatelessWidget {
  void _launchURL(url) async => await canLaunch(url)
      ? await launch(url)
      : LoggerService.log('Could not launch $url', level: "e");

  static String _supportURL =
      RemoteConfigService.remoteConfig.getString("urlSupport");
  static String _websiteURL =
      RemoteConfigService.remoteConfig.getString('urlWebsite');
  static String _privacyURL =
      RemoteConfigService.remoteConfig.getString('urlPrivacy');
  static String _tncURL = RemoteConfigService.remoteConfig.getString('urlTnc');
  static String _licenceURL =
      RemoteConfigService.remoteConfig.getString('urlLicenses');
  static String _transparencyURL =
      RemoteConfigService.remoteConfig.getString('urlTransparency');
  static String _FAQURL = RemoteConfigService.remoteConfig.getString('urlFAQ');

  Future<void> _displayDeleteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return DeleteUserDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
        body: SafeArea(
            child: TextHeaderScreen(
          header: "Settings",
          back: true,
          child: ListView(shrinkWrap: true, children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Learn more",
                    style: Theme.of(context).textTheme.headline4,
                  )),
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Get an overview",
              icon: Icons.directions,
              onPressed: () {
                Navigator.pushNamed(context, '/signup/signupexplainer');
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Visit our website",
              icon: Icons.web_outlined,
              onPressed: () {
                _launchURL(_websiteURL);
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Support us",
              icon: Icons.favorite_outline,
              onPressed: () {
                Navigator.pushNamed(context, '/support/pitch');
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Understand our business",
              icon: Icons.store,
              onPressed: () {
                _launchURL(_transparencyURL);
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Read our FAQ",
              icon: Icons.quiz,
              onPressed: () {
                _launchURL(_FAQURL);
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Get support",
              icon: Icons.chat_bubble_outline_outlined,
              onPressed: () {
                _launchURL(_supportURL);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your account",
                    style: Theme.of(context).textTheme.headline4,
                  )),
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Logout",
              icon: Icons.exit_to_app_outlined,
              onPressed: () {
                user.logout();
                Navigator.popUntil(
                    context, (Route<dynamic> route) => route.isFirst);
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "Delete account",
              icon: Icons.delete_outline_outlined,
              onPressed: () {
                _displayDeleteDialog(context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Legal",
                    style: Theme.of(context).textTheme.headline4,
                  )),
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "View our terms and conditions",
              icon: Icons.description_outlined,
              onPressed: () {
                _launchURL(_tncURL);
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "View our privacy policy",
              icon: Icons.lock_outlined,
              onPressed: () {
                _launchURL(_privacyURL);
              },
            ),
            Divider(
              height: 0,
            ),
            ButtonLight(
              text: "View our licenses",
              icon: Icons.copyright_outlined,
              onPressed: () {
                _launchURL(_licenceURL);
              },
            ),
          ]),
        )),
      );
    });
  }
}
