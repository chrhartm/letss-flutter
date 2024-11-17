import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color? color;
  final double padding;
  const Loader({
    this.padding = 100.0,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(height: padding),
        CircularProgressIndicator(color: color)
      ],
    ));
  }
}
