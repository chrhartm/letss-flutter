import 'package:flutter/material.dart';

class DynamicAppbar extends StatefulWidget {
  final Widget child;
  final String? title;
  final Widget? header;
  final Function? onTap;
  final Widget? trailing;
  final bool back;
  final bool subtitle;
  final bool headerInBody;
  DynamicAppbar(
      {required this.child,
      required this.title,
      this.header,
      this.onTap,
      this.trailing,
      this.headerInBody = false,
      this.subtitle = false,
      this.back = false});
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
        ? Text(
            widget.title!,
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : SizedBox();
    title = hasTitle && widget.onTap != null
        ? GestureDetector(
            onTap: () {
              widget.onTap!();
            },
            child: title,
          )
        : title;
    bool centerTitle = false;
    EdgeInsetsGeometry titlePadding = widget.back
        ? EdgeInsetsDirectional.only(
            start: 50, bottom: 17, end: widget.trailing == null ? 50 : 15)
        : EdgeInsetsDirectional.only(
            start: 15, bottom: 17, end: widget.trailing == null ? 15 : 50);
    bool hasHeader = widget.header != null;
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
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.maybePop(context);
                      })
                  : Container(),
              actions: widget.trailing == null
                  ? []
                  : [
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: widget.trailing!)
                    ],
              pinned: true,
              floating: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              expandedHeight:
                  widget.headerInBody || widget.header == null ? null : height,
              shadowColor: Colors.transparent,
              title: hasHeader ? null : title,
              centerTitle: centerTitle,
              flexibleSpace: hasHeader
                  ? FlexibleSpaceBar(
                      centerTitle: centerTitle,
                      titlePadding: titlePadding,
                      title: title,
                      background: widget.headerInBody
                          ? null
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 50.0,
                                  bottom: 0),
                              child: widget.header))
                  : null,
            )
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
