import 'package:flutter/material.dart';

import '../widgets/tiles/textheaderscreen.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextHeaderScreen(header: "Search", child: Scaffold()));
  }
}
