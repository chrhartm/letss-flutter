import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(padding: EdgeInsets.all(10.0), child: child))));
  }
}
