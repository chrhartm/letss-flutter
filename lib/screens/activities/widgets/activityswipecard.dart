import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/provider/navigationprovider.dart';
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
  const ActivitySwipeCard(
      {super.key, required this.activity, this.back = false});

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
    _controller = AnimationController(
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
      bool joining = widget.activity.joining;
      bool hasParticipants = widget.activity.hasParticipants;
      List<Widget> widgets = [
        Expanded(
            child: ActivityCard(activity: widget.activity, back: widget.back))
      ];
      if (!joining || hasParticipants) {
        widgets.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: ButtonPrimary(
              onPressed: () {
                if (kIsWeb) {
                  Uri uri = Uri.parse("https://letss.app/");
                  launchUrl(uri);
                } else if (user.user.coins > 0 && !joining) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return LikeDialog(
                            activity: widget.activity,
                            controller: widget.back ? null : _controller);
                      });
                } else if (!joining) {
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
                } else if (joining) {
                  Provider.of<NavigationProvider>(context, listen: false)
                      .navigateToActivityChat(context, widget.activity);
                }
              },
              text: kIsWeb
                  ? AppLocalizations.of(context)!.likeDialogWeb
                  : !joining
                      ? AppLocalizations.of(context)!.likeDialogAction
                      : AppLocalizations.of(context)!.likeDialogChat,
            )));
      }
      return SlideTransition(
          position: _animation,
          child: Scaffold(body: Column(children: widgets)));
    });
  }
}
