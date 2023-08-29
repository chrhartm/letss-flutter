import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'tile.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class TextTile extends StatelessWidget {
  const TextTile({Key? key, required this.title, required this.text})
      : super(key: key);

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Tile(
        child: Column(children: [
      Align(
          alignment: Alignment.topLeft,
          child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
      const SizedBox(height: 5),
      Align(
          alignment: Alignment.topLeft,
          child: Linkify(
            onOpen: (link) async {
              if (!await launchUrl(Uri.parse(link.url))) {
                throw Exception('Could not launch ${link.url}');
              }
            },
            text: text,
            style: Theme.of(context).textTheme.bodyLarge,
            strutStyle: StrutStyle(forceStrutHeight: true),
            linkStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(decoration: TextDecoration.underline),
          ))
    ]));
  }
}
