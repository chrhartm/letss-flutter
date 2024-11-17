import 'package:flutter/material.dart';
import 'package:letss_app/backend/loggerservice.dart';

class RouteProvider extends ChangeNotifier {
  String _currentRoute = '/';
  String _baseRoute = '/';

  set baseRoute(String route) {
    LoggerService.log("Base route changed to: $route");
    _baseRoute = route;
  }

  String get currentRoute {
    if (_currentRoute == "/") {
      return _baseRoute;
    }
    return _currentRoute;
  }

  void updateRoute(String route) {
    LoggerService.log("Route changed to: $route");
    _currentRoute = route;
  }
}
