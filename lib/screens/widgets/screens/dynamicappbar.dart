import 'package:flutter/material.dart';

class DynamicAppbar extends StatefulWidget {
  final Widget child;
  final String? title;
  final Widget expandedTitle;
  final bool back;
  final bool subtitle;
  final bool headerInBody;
  DynamicAppbar(
      {required this.child,
      required this.title,
      required this.expandedTitle,
      this.headerInBody = false,
      this.subtitle = false,
      this.back = false});
  @override
  State<DynamicAppbar> createState() => _DynamicAppbarState();
}

class _DynamicAppbarState extends State<DynamicAppbar> {
  late ScrollController _scrollController;
  bool lastStatus = true;
  late double height = (widget.subtitle ? 160 : 100);
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
              pinned: true,
              floating: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              expandedHeight: widget.headerInBody ? null : height,
              shadowColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  titlePadding: widget.back
                      ? EdgeInsetsDirectional.only(
                          start: 50, bottom: 17, end: 15)
                      : EdgeInsetsDirectional.only(
                          start: 15, bottom: 17, end: 15),
                  title: _isShrink && widget.title != null
                      ? Text(
                          widget.title!,
                          style: Theme.of(context).textTheme.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox(),
                  background: widget.headerInBody
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 50.0, bottom: 0),
                          child: widget.expandedTitle)),
            )
          ],
          reverse: false,
          body: Padding(
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 0),
            child: widget.headerInBody
                ? Column(children: [
                    widget.expandedTitle,
                    const SizedBox(height: 10),
                    Expanded(child: widget.child)
                  ])
                : widget.child,
          ),
        ));
  }
}
