import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/activities/widgets/activitycard.dart';
import 'package:letss_app/screens/widgets/buttons/buttonaction.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import 'likedialog.dart';

class ActivitySwipeCard extends StatefulWidget {
  const ActivitySwipeCard({Key? key, required this.activity, this.back = false})
      : super(key: key);

  final Activity activity;
  final bool back;

  @override
  ActivitySwipeCardState createState() => ActivitySwipeCardState();
}

class ActivitySwipeCardState extends State<ActivitySwipeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInToLinear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      ActivitiesProvider activities =
          Provider.of<ActivitiesProvider>(context, listen: false);
      List<Widget> buttons = [];
      if (user.featureSearch) {
        buttons.addAll([
          ButtonAction(
              onPressed: () {
                Navigator.pushNamed(context, '/activities/search');
              },
              icon: Icons.search),
          const SizedBox(height: ButtonAction.buttonGap),
        ]);
      }
      buttons.addAll([
        ButtonAction(
            onPressed: () {
              analytics.logEvent(name: "Activity_Share");
              activities.share(widget.activity);
            },
            icon: Icons.share),
        const SizedBox(height: ButtonAction.buttonGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ButtonAction(
                onPressed: () {
                  analytics.logEvent(name: "Activity_Pass");
                  if (this.widget.back) {
                    activities.pass(widget.activity);
                    Navigator.pop(context);
                  } else {
                    _controller
                        .forward()
                        .whenComplete(() => activities.pass(widget.activity));
                  }
                },
                icon: Icons.not_interested),
            const SizedBox(width: ButtonAction.buttonGap),
            ButtonAction(
                onPressed: () {
                  analytics.logEvent(name: "Activity_Like");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return LikeDialog(
                            activity: widget.activity,
                            controller: this.widget.back ? null : _controller);
                      });
                },
                icon: Icons.pan_tool,
                heroTag: "like_${widget.activity.uid}",
                coins: user.user.coins),
          ],
        )
      ]);

      return SlideTransition(
          position: _animation,
          child: Scaffold(
              body: ActivityCard(
                  activity: widget.activity, back: this.widget.back),
              floatingActionButton: Padding(
                  padding: ButtonAction.buttonPadding,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: buttons)))));
    });
  }
}
