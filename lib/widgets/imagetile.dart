import 'package:flutter/material.dart';
import 'tile.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({Key? key, required this.title, required this.image})
      : super(key: key);

  final String title;
  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Tile(
      child: AspectRatio(aspectRatio: 1 / 1, child: image),
      padding: true,
    );
  }
}
