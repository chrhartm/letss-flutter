import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.child,
    this.padding: true,
  }) : super(key: key);

  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    double padding_size = 0;
    if (padding) {
      padding_size = 10;
    }
    return Container(
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                    padding: EdgeInsets.all(padding_size), child: child))));
  }
}
