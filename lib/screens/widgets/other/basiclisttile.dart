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
  final void Function()? onTap;

  const BasicListTile(
      {Key? key,
      required this.title,
      this.subtitle,
      this.boldSubtitle = false,
      this.leading,
      this.trailing,
      this.primary = false,
      this.underlined = false,
      this.onTap,
      this.noPadding = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titlestyle = primary
        ? Theme.of(context).textTheme.headlineMedium!
        : Theme.of(context).textTheme.bodyLarge!;
    TextStyle readstyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: Theme.of(context).colorScheme.secondary);
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);

    Widget titleWidget = Underlined(
        text: title,
        maxLines: 1,
        underlined: underlined,
        overflow: TextOverflow.ellipsis,
        style: titlestyle);

    return ListTile(
        title: titleWidget,
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: boldSubtitle ? unreadstyle : readstyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
            : null,
        leading: leading,
        trailing: trailing,
        contentPadding: noPadding ? EdgeInsets.fromLTRB(0, 0, 0, 0) : null,
        onTap: onTap);
  }
}
