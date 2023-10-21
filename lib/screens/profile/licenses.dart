import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Licenses extends StatelessWidget {
  final MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );

  late final PackageInfo package;

  Licenses(PackageInfo package) {
    this.package = package;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData defaultTheme = Theme.of(context);

    return MyScaffold(
        body: Theme(
      data: ThemeData(
        cardColor: Colors.white,
        primaryColor: defaultTheme.colorScheme.background,
        primarySwatch: white,
      ),
      child: LicensePage(
        applicationVersion: package.version + '+' + package.buildNumber,
        applicationLegalese:
            AppLocalizations.of(context)!.licensesRightsReserved,
      ),
    ));
  }
}
