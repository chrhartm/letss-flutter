import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.child,
    this.padding = true,
  }) : super(key: key);

  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    double paddingSize = 0;
    if (padding) {
      paddingSize = 10;
    }
    return Container(
        width: double.infinity,
        child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: EdgeInsets.only(top: paddingSize, bottom: paddingSize),
                child: child)));
  }
}
