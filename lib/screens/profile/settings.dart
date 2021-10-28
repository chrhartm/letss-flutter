import 'package:flutter/material.dart';
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

  static const _supportURL = 'mailto:christoph@letss.app';
  static const _websiteURL = 'https://letss.app';
  static const _privacyURL = 'https://letss.app/privacy';
  static const _tncURL = 'https://letss.app/tnc';
  static const _licenceURL = 'https://letss.app/licences';

  Future<void> _displayDeleteDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure you want to delete your account?',
                style: Theme.of(context).textTheme.headline4),
            content: null,
            actions: <Widget>[
              TextButton(
                child: Text('Back',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                onPressed: () {
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
              ),
              TextButton(
                child: Text('Delete',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
                onPressed: () {
                  UserProvider user = Provider.of<UserProvider>(context);
                  user.delete().then((val) => user.logout());
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
              ),
            ],
          );
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
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Get in touch",
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
                        "Account",
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
                        "Legal",
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
