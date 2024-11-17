import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Licenses extends StatelessWidget {
  final MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  final PackageInfo package;

  const Licenses({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    ThemeData defaultTheme = Theme.of(context);

    return MyScaffold(
        body: Theme(
      data: ThemeData(
        cardColor: Colors.white,
        primaryColor: defaultTheme.colorScheme.surface,
        primarySwatch: white,
      ),
      child: LicensePage(
        applicationVersion: "${package.version}+${package.buildNumber}",
        applicationLegalese:
            AppLocalizations.of(context)!.licensesRightsReserved,
      ),
    ));
  }
}
