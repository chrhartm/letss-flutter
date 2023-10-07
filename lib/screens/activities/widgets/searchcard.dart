import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/screens/activities/widgets/activityswipecard.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../widgets/other/loader.dart';

class SearchCard extends StatelessWidget {
  const SearchCard(
    Activity activity, {
    Key? key,
  })  : this.activity = activity,
        super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Loader(),
        ),
        overlayOpacity: 0.6,
        overlayColor: Colors.black.withOpacity(0.6),
        child: Scaffold(
            body: SafeArea(
          child: ActivitySwipeCard(activity: activity, back: true),
        )));
  }
}
