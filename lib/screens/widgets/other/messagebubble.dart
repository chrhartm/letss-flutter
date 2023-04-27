import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/theme.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    Key? key,
    required this.message,
    required this.me,
  }) : super(key: key);

  final String message;
  final bool me;

  final BorderRadius meRadius = BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
      topRight: Radius.circular(10));

  final BorderRadius youRadius = BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
      topRight: Radius.circular(10));

  final meColor = apptheme.colorScheme.primaryContainer;
  final youColor = apptheme.colorScheme.primary;

  final meTextColor = apptheme.colorScheme.onPrimary;
  final youTextColor = apptheme.colorScheme.onPrimary;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: me ? meTextColor : youTextColor);
    return Align(
        alignment: me ? Alignment.topRight : Alignment.topLeft,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: me ? meColor : youColor,
              borderRadius: me ? meRadius : youRadius,
            ),
            child: LinkifyText(this.message,
                textAlign: me ? TextAlign.right : TextAlign.left,
                linkTypes: [LinkType.url],
                strutStyle: StrutStyle(forceStrutHeight: true),
                textStyle: textStyle,
                linkStyle: textStyle.copyWith(
                    decoration: TextDecoration.underline), onTap: (link) {
              String value = link.value!;
              if (!value.contains(":")) {
                value = "https://" + link.value!;
              }
              launchUrl(Uri.parse(value)).onError((error, stackTrace) =>
                  LoggerService.log("Error in opening URL"));
            })));
  }
}
