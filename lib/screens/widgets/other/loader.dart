import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color? color;
  final double padding;
  const Loader({
    double padding = 100.0,
    Color? color,
    Key? key,
  })  : color = color,
        padding = padding,
        super(key: key);

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
