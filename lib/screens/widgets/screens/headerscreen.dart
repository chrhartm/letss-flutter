import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/screens/dynamicappbar.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen(
      {Key? key,
      required this.child,
      this.back = false,
      this.underlined = false,
      this.onlyAppBar = false,
      this.leading,
      this.onTap,
      this.title,
      this.titleWidget,
      this.subtitle,
      this.trailing,
      this.top})
      : super(key: key);

  final Widget child;
  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final String? top;
  final Function? onTap;
  final Widget? trailing;
  final bool back;
  final bool underlined;
  final bool onlyAppBar;

  Widget _buildHeader(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.displayMedium!;
    String title = this.title ?? "";
    String subtitle = this.subtitle ?? "";
    List<Widget> children = [];
    children.addAll([
      Align(
          alignment: Alignment.topLeft,
          child: titleWidget != null
              ? titleWidget
              : underlined
                  ? Underlined(
                      text: title,
                      style: Theme.of(context).textTheme.displayLarge!,
                      maxLines: null,
                    )
                  : Text(
                      this.top == null ? title : title + "\u{00A0}" + this.top!,
                      style: style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
    ]);
    if (this.subtitle != null) {
      children.addAll([
        const SizedBox(height: 5),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
      ]);
    }
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    Widget? header = onlyAppBar ? null : _buildHeader(context);
    return DynamicAppbar(
      child: child,
      leading: leading,
      title: title,
      header: onlyAppBar ? null : header!,
      back: back,
      subtitle: subtitle != null,
      onTap: onTap,
      trailing: trailing,
      headerInBody: underlined,
      underlined: underlined,
    );
  }
}
