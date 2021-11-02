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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0, bottom: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "",
                        style: Theme.of(context).textTheme.headline2,
                      )),
                ),
                Divider(
                  height: 0,
                ),
                ButtonLight(
                  text: "Contact support",
                  onPressed: () {
                    _launchURL(_supportURL);
                  },
                ),
                Divider(
                  height: 0,
                ),
                ButtonLight(
                  text: "Visit our website",
                  onPressed: () {
                    _launchURL(_websiteURL);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "",
                        style: Theme.of(context).textTheme.headline2,
                      )),
                ),
                Divider(
                  height: 0,
                ),
                ButtonLight(
                  text: "Logout",
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
                  onPressed: () {
                    _displayDeleteDialog(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "",
                        style: Theme.of(context).textTheme.headline2,
                      )),
                ),
                Divider(
                  height: 0,
                ),
                ButtonLight(
                  text: "Read our terms and conditions",
                  onPressed: () {
                    _launchURL(_tncURL);
                  },
                ),
                Divider(
                  height: 0,
                ),
                ButtonLight(
                  text: "Read our privacy policy",
                  onPressed: () {
                    _launchURL(_privacyURL);
                  },
                ),
                Divider(
                  height: 0,
                ),
                ButtonLight(
                  text: "Read the licenses",
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
