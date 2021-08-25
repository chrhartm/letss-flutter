import 'package:flutter/material.dart';

class DummyImage extends StatelessWidget {
  const DummyImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, color: Colors.grey[400]);
  }
}
