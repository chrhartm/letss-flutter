import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';

class DynamicAppbar extends StatefulWidget {
  final Widget child;
  final String? title;
  final Widget? header;
  final Widget? leading;
  final Function? onTap;
  final Widget? trailing;
  final bool back;
  final bool subtitle;
  final bool headerInBody;
  final bool underlined;
  DynamicAppbar(
      {required this.child,
      required this.title,
      this.leading,
      this.header,
      this.onTap,
      this.trailing,
      this.headerInBody = false,
      this.subtitle = false,
      this.back = false,
      this.underlined = false});
  @override
  State<DynamicAppbar> createState() => _DynamicAppbarState();
}

class _DynamicAppbarState extends State<DynamicAppbar> {
  late ScrollController _scrollController;
  bool lastStatus = true;

  late double height = (widget.subtitle
      ? 140
      : (widget.header == null)
          ? 0
          : 100);
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasTitle = _isShrink && widget.title != null || widget.header == null;
    Widget title = hasTitle
        ? Underlined(
            text: widget.title!,
            style: Theme.of(context).textTheme.headlineMedium!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            underlined: widget.underlined,
          )
        : SizedBox();
    title = widget.leading != null
        ? Row(
            children: [
              widget.leading!,
              SizedBox(width: 10),
              Expanded(child: title),
            ],
          )
        : title;
    title = hasTitle && widget.onTap != null
        ? GestureDetector(
            onTap: () {
              widget.onTap!();
            },
            child: title,
          )
        : title;
    bool centerTitle = false;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
                leading: widget.back
                    ? IconButton(
                        splashColor: Colors.transparent,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(kIsWeb || Platform.isAndroid
                            ? Icons.arrow_back
                            : Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.maybePop(context);
                        })
                    : null,
                titleSpacing: widget.back ? -10 : 15,
                actions: widget.trailing == null
                    ? []
                    : [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: widget.trailing!)
                      ],
                pinned: true,
                floating: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                expandedHeight: widget.headerInBody || widget.header == null
                    ? null
                    : height,
                shadowColor: Colors.transparent,
                title: title,
                centerTitle: centerTitle,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: centerTitle,
                    titlePadding: null,
                    title: null,
                    background: widget.headerInBody
                        ? null
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 50.0, bottom: 0),
                            child: widget.header)))
          ],
          body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 0),
            child: widget.headerInBody && !(widget.header == null)
                ? ListView(
                    children: [
                      widget.header!,
                      const SizedBox(height: 10),
                      widget.child
                    ],
                    shrinkWrap: true,
                  )
                : widget.child,
          ),
        ));
  }
}
