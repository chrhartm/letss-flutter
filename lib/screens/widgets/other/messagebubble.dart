import 'package:flutter/material.dart';
import 'package:letss_app/models/person.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../../../theme/theme.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {Key? key,
      required this.message,
      required this.me,
      this.speaker,
      this.firstMessage = false,
      this.lastMessage = false,
      this.multiPerson = false})
      : super(key: key);

  final String message;
  final Person? speaker;
  final bool firstMessage;
  final bool lastMessage;
  final bool me;
  final bool multiPerson;

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
    List<Widget> elements = [];
    if (firstMessage && speaker != null && !me && multiPerson) {
      elements.add(Text(speaker!.name,
          textAlign: TextAlign.left,
          strutStyle: StrutStyle(forceStrutHeight: true),
          style: textStyle.copyWith(fontWeight: FontWeight.bold)));
      elements.add(SizedBox(width: 5));
    }
    final fontSize =
        textStyle.fontSize! * MediaQuery.of(context).textScaleFactor;
    elements.add(Linkify(
      onOpen: (link) async {
        if (!await launchUrl(Uri.parse(link.url))) {
          throw Exception('Could not launch ${link.url}');
        }
      },
      text: this.message,
      style: textStyle.copyWith(fontSize: fontSize),
      linkStyle: textStyle.copyWith(
          decoration: TextDecoration.underline, fontSize: fontSize),
    ));

    List<Widget> rowElements = [];
    if (!me && speaker != null && multiPerson) {
      lastMessage
          ? rowElements.add(speaker!.smallThumbnail)
          : rowElements.add(SizedBox(width: 14 * 2));
      rowElements.add(SizedBox(width: 5));
    }
    rowElements.add(Container(
        constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * (multiPerson ? 0.65 : 0.7)),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: me ? meColor : youColor,
          borderRadius: me ? meRadius : youRadius,
        ),
        child: Column(
          children: elements,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        )));

    return Align(
        alignment: me ? Alignment.topRight : Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              me ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: rowElements,
        ));
  }
}
