import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:letss_app/backend/genericconfigservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void _launchURL(String url) async {
  Uri uri = Uri.parse(url);
  await canLaunchUrl(uri)
      ? await launchUrl(uri)
      : LoggerService.log('Could not open $url', level: "w");
}

class SupportInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle headingStyle = Theme.of(context).textTheme.headlineMedium!;
    TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;
    TextStyle emojiStyle = Theme.of(context).textTheme.displayMedium!;
    return Container(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Text("🙌", style: emojiStyle)),
            Align(
                alignment: Alignment.topLeft,
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!.supportInfo1,
                            style: headingStyle),
                        TextSpan(
                            text:
                                AppLocalizations.of(context)!.supportInfo2,
                            style: bodyStyle),
                        TextSpan(
                            text: AppLocalizations.of(context)!.supportInfo3,
                            style: headingStyle),
                        TextSpan(
                          text:
                             AppLocalizations.of(context)!.supportInfo4,
                          style: bodyStyle,
                        ),
                        TextSpan(
                            text: AppLocalizations.of(context)!.supportInfo5,
                            style: headingStyle),
                        TextSpan(
                            text:
                               AppLocalizations.of(context)!.supportInfo6,
                            style: bodyStyle),
                        TextSpan(
                            text: AppLocalizations.of(context)!.supportInfo7,
                            style: new TextStyle(color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                _launchURL(GenericConfigService.config
                                    .getString("urlSupport"));
                              }),
                        TextSpan(text: AppLocalizations.of(context)!.supportInfo8, style: bodyStyle),
                      ],
                    ))),
            const SizedBox(height: 30),
          ])))),
    );
  }
}
