import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/other/loader.dart';

import '../theme/theme.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Letss",
      debugShowCheckedModeBanner: false,
      theme: apptheme,
      home: MyScaffold(body: Loader(), withSafeArea: false),

    );
  }
}
