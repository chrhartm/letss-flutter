import 'package:flutter/material.dart';

import '../tiles/widgets/underlined.dart';

class BasicListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool boldSubtitle;
  final bool primary;
  final bool underlined;
  final bool noPadding;
  final bool threeLines;
  final void Function()? onTap;

  const BasicListTile(
      {super.key,
      required this.title,
      this.subtitle,
      this.boldSubtitle = false,
      this.leading,
      this.trailing,
      this.primary = false,
      this.underlined = false,
      this.threeLines = false,
      this.onTap,
      this.noPadding = false});

  @override
  Widget build(BuildContext context) {
    TextStyle titlestyle = primary
        ? Theme.of(context).textTheme.headlineMedium!
        : Theme.of(context).textTheme.bodyLarge!;
    TextStyle readstyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: Theme.of(context).colorScheme.secondary);
    TextStyle unreadstyle = readstyle.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary);

    Widget titleWidget = Underlined(
        text: title,
        maxLines: 1,
        underlined: underlined,
        overflow: TextOverflow.ellipsis,
        style: titlestyle);

    Widget? leading = this.leading;
    leading ??=
        CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary);

    return ListTile(
        isThreeLine: threeLines,
        enabled: onTap != null,
        title: titleWidget,
        // visualDensity: VisualDensity(vertical: 1),
        dense: false,
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: boldSubtitle ? unreadstyle : readstyle,
                maxLines: threeLines ? 2 : 1,
                overflow: TextOverflow.ellipsis)
            : null,
        leading: Container(width: 48, height: 48, child: leading),
        trailing: trailing,
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: noPadding ? EdgeInsets.fromLTRB(0, 0, 0, 0) : null,
        onTap: onTap);
  }
}
