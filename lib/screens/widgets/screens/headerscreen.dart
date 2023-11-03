import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/screens/dynamicappbar.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';

class HeaderScreen extends StatelessWidget {
  const HeaderScreen(
      {Key? key,
      required this.child,
      this.back = false,
      this.underlined = false,
      this.title,
      this.subtitle,
      this.top})
      : super(key: key);

  final Widget child;
  final String? title;
  final String? subtitle;
  final String? top;
  final bool back;
  final bool underlined;

  Widget _buildHeader(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.displayMedium!;
    String title = this.title ?? "";
    String subtitle = this.subtitle ?? "";
    List<Widget> children = [];
    children.addAll([
      Align(
          alignment: Alignment.topLeft,
          child: underlined
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
    Widget header = _buildHeader(context);
    return DynamicAppbar(
      child: child,
      title: title,
      expandedTitle: header,
      back: back,
      subtitle: subtitle != null,
      headerInBody: underlined,
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    Widget header = _buildHeader(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 0),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              List<Widget> slivers = [];

              if (this.back) {
                slivers.add(SliverAppBar(
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Container(),
                  ),
                  title: IconButton(
                      splashColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.maybePop(context);
                      }),
                  pinned: true,
                  centerTitle: false,
                  titleSpacing: 0,
                  automaticallyImplyLeading: false,
                  shadowColor: Colors.transparent,
                  backgroundColor: Theme.of(context).colorScheme.background,
                ));
              }

              slivers.add(SliverAppBar(
                title: header,
                pinned: true,
                floating: false,
                centerTitle: false,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                shadowColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.background,
              ));

              slivers.add(SliverFillRemaining(
                hasScrollBody: true,
                child:
                    Container(height: constraints.maxHeight, child: this.child),
              ));
              return CustomScrollView(slivers: slivers);
            })));
  }
  */
}
