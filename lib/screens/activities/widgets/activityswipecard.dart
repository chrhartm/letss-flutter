import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/activities/widgets/activitycard.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import 'likedialog.dart';

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
                    if (kIsWeb) {
                      Uri uri = Uri.parse("https://letss.page.link/4vDS");
                      launchUrl(uri);
                    } else if (user.user.coins > 0) {
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
                  text: kIsWeb?AppLocalizations.of(context)!.likeDialogWeb:AppLocalizations.of(context)!.likeDialogAction,
                ))
          ])));
    });
  }
}
