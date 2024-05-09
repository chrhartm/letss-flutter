import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  // Put to other instead of none so that on startup it doesn't show dialog
  ConnectivityResult _status = ConnectivityResult.other;
  bool _dialogOpen = false;

  ConnectivityProvider() {
    _initConnectivity();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    _status = results.first;
    notifyListeners();
  }

  ConnectivityResult get status => _status;

  bool get dialogOpen => _dialogOpen;

  set dialogOpen(bool value) {
    _dialogOpen = value;
  }

  void notify() {
    notifyListeners();
  }
}
