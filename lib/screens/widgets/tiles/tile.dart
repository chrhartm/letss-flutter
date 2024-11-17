import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.child,
    this.padding = true,
  });

  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    double paddingSize = 0;
    if (padding) {
      paddingSize = 10;
    }
    return SizedBox(
        width: double.infinity,
        child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: EdgeInsets.only(bottom: paddingSize), child: child)));
  }
}
