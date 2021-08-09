import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'tile.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({Key? key, required this.title, required this.image})
      : super(key: key);

  final String title;
  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Tile(
      child: Image.memory(image,
          semanticLabel: title, height: 300, fit: BoxFit.cover),
      padding: false,
    );
  }
}
