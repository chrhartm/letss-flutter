import 'package:flutter/material.dart';

// TODO use this everywhere
class BasicListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  const BasicListTile(
      {Key? key,
      required this.title,
      this.subtitle = null,
      this.leading = null,
      this.trailing = null,
      this.onTap = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: Theme.of(context).textTheme.bodyLarge!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: Theme.of(context).textTheme.bodyMedium!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis)
            : null,
        leading: leading,
        trailing: trailing,
        onTap: onTap);
  }
}
