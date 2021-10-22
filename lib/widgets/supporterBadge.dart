import 'package:flutter/material.dart';

class SupporterBadge extends StatelessWidget {
  const SupporterBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5), child: Text("🙌"));
  }
}
