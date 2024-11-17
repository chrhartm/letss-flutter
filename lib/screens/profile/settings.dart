import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/genericconfigservice.dart';
import 'package:letss_app/screens/profile/licenses.dart';
import 'package:letss_app/screens/profile/widgets/deleteuserdialog.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/buttons/buttonlight.dart';
import '../../provider/userprovider.dart';
import '../../backend/loggerservice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    await canLaunchUrl(uri)
        ? await launchUrl(uri)
        : LoggerService.log('Could not open $url', level: "w");
  }

  static final String _supportURL =
      GenericConfigService.config.getString("urlSupport");
  static final String _privacyURL =
      GenericConfigService.config.getString('urlPrivacy');
  static final String _tncURL = GenericConfigService.config.getString('urlTnc');
  static final String _faqURL = GenericConfigService.config.getString('urlFAQ');

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
      return MyScaffold(
          body: HeaderScreen(
        title: AppLocalizations.of(context)!.settingsTitle,
        back: true,
        child: ListView(shrinkWrap: true, children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.settingsLearnMore,
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsGetOverview,
            icon: Icons.directions,
            onPressed: () {
              Navigator.pushNamed(context, '/signup/signupexplainer');
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsSupportUs,
            icon: Icons.favorite_outline,
            onPressed: () {
              Navigator.pushNamed(context, '/support/pitch');
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsReadFAQ,
            icon: Icons.quiz,
            onPressed: () {
              _launchURL(_faqURL);
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsGetSupport,
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
                  AppLocalizations.of(context)!.settingsYourAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsAppSettings,
            icon: Icons.settings_applications_outlined,
            onPressed: () {
              AppSettings.openAppSettings();
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsLogout,
            icon: Icons.exit_to_app_outlined,
            onPressed: () {
              user.logout();
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
              text: AppLocalizations.of(context)!.settingsDeleteAccount,
              icon: Icons.delete_outline_outlined,
              onPressed: () {
                _displayDeleteDialog(context);
              }),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.settingsLegal,
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsToC,
            icon: Icons.description_outlined,
            onPressed: () {
              _launchURL(_tncURL);
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsPrivacy,
            icon: Icons.lock_outlined,
            onPressed: () {
              _launchURL(_privacyURL);
            },
          ),
          Divider(height: 0, color: Theme.of(context).colorScheme.primary),
          ButtonLight(
            text: AppLocalizations.of(context)!.settingsLicenses,
            icon: Icons.copyright,
            onPressed: () {
              PackageInfo.fromPlatform().then((PackageInfo package) {
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                      settings:
                          const RouteSettings(name: '/myactivities/activity'),
                      builder: (context) => Licenses(package: package)));
                }
              });
            },
          ),
        ]),
      ));
    });
  }
}
