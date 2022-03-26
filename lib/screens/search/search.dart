import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/search/widgets/searchDisabled.dart';
import 'package:provider/provider.dart';

import '../widgets/tiles/textheaderscreen.dart';

Widget _buildContent(UserProvider user) {
  if (user.searchEnabled) {
    return Container(
        child: Center(
            child: Text(
      "Search is currently disabled",
      style: TextStyle(fontSize: 20),
    )));
  } else {
    return SearchDisabled();
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: TextHeaderScreen(
              back: false, header: "Search", child: _buildContent(user)));
    });
  }
}
