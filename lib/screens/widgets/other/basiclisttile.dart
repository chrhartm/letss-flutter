import 'package:flutter/material.dart';

// TODO use this everywhere
class BasicListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool boldSubtitle;
  final EdgeInsetsGeometry? contentPadding;
  final void Function()? onTap;

  const BasicListTile(
      {Key? key,
      required this.title,
      this.subtitle = null,
      this.boldSubtitle = false,
      this.leading = null,
      this.trailing = null,
      this.onTap = null,
      this.contentPadding = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle readstyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: Theme.of(context).colorScheme.secondary);
    TextStyle unreadstyle = readstyle.copyWith(fontWeight: FontWeight.bold);

    return ListTile(
        title: Text(title,
            style: Theme.of(context).textTheme.bodyLarge!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: boldSubtitle ? unreadstyle : readstyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
            : null,
        leading: leading,
        trailing: trailing,
        contentPadding: contentPadding,
        onTap: onTap);
  }
}
