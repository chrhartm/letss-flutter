import 'package:flutter/material.dart';

class RouteProvider extends ChangeNotifier {
  String _currentRoute = '/';
  String _baseRoute = '/';

  set baseRoute(String route) {
    _baseRoute = route;
  }

  String get currentRoute {
    if (_currentRoute == "/") {
      return _baseRoute;
    }
    return _currentRoute;
  }

  void updateRoute(String route) {
    _currentRoute = route;
  }
}
