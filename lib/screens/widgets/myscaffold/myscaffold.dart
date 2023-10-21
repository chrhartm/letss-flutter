import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/connectivitywrapper.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MyScaffold extends StatelessWidget {
  final Widget body;
  final bool withSafeArea;
  final BottomNavigationBar? bottomNavigationBar;
  final Widget? floatingActionButton;

  MyScaffold(
      {required this.body,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.withSafeArea = true});

  @override
  Widget build(BuildContext context) {
    Widget scaffoldBody = withSafeArea
        ? SafeArea(
            child: ConnectivityWrapper(child: body),
          )
        : ConnectivityWrapper(child: body);
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        // TODO Future workaround, check in next version of lib, check in all places
        overlayColor: Colors.black.withOpacity(0.6),
        child: Scaffold(
          body: scaffoldBody,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ));
  }
}
