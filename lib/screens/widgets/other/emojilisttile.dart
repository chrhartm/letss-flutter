import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/other/BasicListTile.dart';

class EmojiListTile extends StatelessWidget {
  final String title;
  final String emoji;
  final String? subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  const EmojiListTile(
      {super.key,
      required this.title,
      required this.emoji,
      this.subtitle,
      this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return BasicListTile(
        title: title,
        subtitle: subtitle,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Text(emoji, style: Theme.of(context).textTheme.displayMedium),
        ),
        trailing: trailing,
        onTap: onTap);
  }
}
