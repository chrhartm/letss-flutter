import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/activities/widgets/activitycard.dart';
import 'package:letss_app/screens/widgets/buttons/buttonaction.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import 'likedialog.dart';
import 'dart:io' show Platform;

import 'nocoinsdialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      if (!widget.back) {
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
              context.loaderOverlay.show();
              activities
                  .share(widget.activity)
                  .then(((_) => context.loaderOverlay.hide()))
                  .onError((error, stackTrace) =>
                      (error, stackTrace) => context.loaderOverlay.hide());
            },
            icon: !kIsWeb && Platform.isIOS ? Icons.ios_share : Icons.share),
        const SizedBox(height: ButtonAction.buttonGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ButtonAction(
                onPressed: () {
                  if (user.user.coins > 0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return LikeDialog(
                              activity: widget.activity,
                              controller:
                                  this.widget.back ? null : _controller);
                        });
                  } else {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        isDismissible: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                        ),
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                              heightFactor: 0.3, child: NoCoinsDialog());
                        });
                  }
                },
                icon: Icons.add,
                heroTag: "like_${widget.activity.uid}",
                coins: user.user.coins),
          ],
        )
      ]);

      return SlideTransition(
          position: _animation,
          child: Scaffold(
              body: Column(children: [
            Expanded(
                child: ActivityCard(
                    activity: widget.activity, back: this.widget.back)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ButtonPrimary(
                  active: !widget.activity.participants
                      .any((element) => element.uid == user.user.person.uid),
                  onPressed: () {
                    if (user.user.coins > 0) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return LikeDialog(
                                activity: widget.activity,
                                controller:
                                    this.widget.back ? null : _controller);
                          });
                    } else {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0)),
                          ),
                          builder: (BuildContext context) {
                            return FractionallySizedBox(
                                heightFactor: 0.3, child: NoCoinsDialog());
                          });
                    }
                  },
                  text: AppLocalizations.of(context)!.likeDialogAction,
                ))
          ])));
    });
  }
}
