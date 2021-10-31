import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Letss",
      home: SafeArea(
        child: Loader(),
      ),
    );
  }
}
