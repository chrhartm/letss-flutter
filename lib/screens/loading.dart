import 'package:flutter/material.dart';
import '../widgets/loader.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Letss",
      home: SafeArea(
        child: Scaffold(
          body: Loader(),
        ),
      ),
    );
  }
}
