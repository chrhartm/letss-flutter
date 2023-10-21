import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:letss_app/provider/connectivityprovider.dart';
import 'package:letss_app/screens/widgets/myscaffold/noconnectivitydialog.dart';
import 'package:provider/provider.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  ConnectivityWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(builder: (context, conn, _child) {
      if (conn.status == ConnectivityResult.none && !conn.dialogOpen) {
        Future.delayed(Duration.zero, () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              conn.dialogOpen = true;
              return NoConnectivityDialog();
            },
          );
        });
      }

      return child;
    });
  }
}
