import 'package:flutter/material.dart';
import '../../widgets/tiles/tile.dart';
import '../../widgets/other/messagebubble.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.text, required this.me})
      : super(key: key);

  final String text;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Tile(child: MessageBubble(message: this.text, me: this.me));
  }
}
