import 'package:flutter/material.dart';
import 'package:letss_app/backend/analyticsservice.dart';
import 'package:letss_app/provider/activitiesprovider.dart';
import 'package:letss_app/screens/widgets/buttons/buttonaction.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import '../../../provider/userprovider.dart';
import 'package:provider/provider.dart';
import '../../../models/activity.dart';
import '../../../models/person.dart';
import '../../widgets/tiles/texttile.dart';
import '../../widgets/tiles/tagtile.dart';
import '../../widgets/tiles/imagetile.dart';
import '../../widgets/tiles/nametile.dart';
import 'likedialog.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({
    Key? key,
    required this.activity,
    this.back = false,
  }) : super(key: key);

  final Activity activity;
  final bool back;

  @override
  ActivityCardState createState() => ActivityCardState();
}

class ActivityCardState extends State<ActivityCard>
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

  List<Widget> buildList(Person userPerson) {
    Person person = widget.activity.person;

    List<Widget> widgets = [
      const SizedBox(height: 0),
      ImageTile(title: "user picture", image: person.profilePic),
      const SizedBox(height: 0),
      NameTile(person: person),
      const SizedBox(height: 0),
      TextTile(title: "activity", text: widget.activity.description),
      const SizedBox(height: 0),
      TagTile(
        tags: widget.activity.categories,
        otherTags: userPerson.interests,
      ),
      const SizedBox(height: 0),
      TextTile(title: "bio", text: person.bio)
    ];
    if (userPerson.uid != widget.activity.person.uid) {
      widgets.add(FlagTile(
          flagger: userPerson,
          flagged: widget.activity.person,
          activity: widget.activity));
    }
    widgets.add(const SizedBox(height: 150));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      ActivitiesProvider activities =
          Provider.of<ActivitiesProvider>(context, listen: false);
      return SlideTransition(
          position: _animation,
          child: Scaffold(
              body: Card(
                borderOnForeground: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0),
                  borderRadius: BorderRadius.circular(0),
                ),
                margin: EdgeInsets.zero,
                child: TextHeaderScreen(
                  header: widget.activity.name,
                  back: widget.back,
                  child: ListView(children: buildList(user.user.person)),
                ),
                elevation: 0,
              ),
              floatingActionButton: Padding(
                  padding: ButtonAction.buttonPadding,
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonAction(
                              onPressed: () {
                                analytics.logEvent(name: "Activity_Share");
                                activities.share();
                              },
                              icon: Icons.share,
                              hero: null,
                            ),
                            const SizedBox(height: ButtonAction.buttonGap),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ButtonAction(
                                  onPressed: () {
                                    analytics.logEvent(name: "Activity_Pass");
                                    _controller
                                        .forward()
                                        .whenComplete(() => activities.pass());
                                    ;
                                  },
                                  icon: Icons.not_interested,
                                  hero: null,
                                ),
                                const SizedBox(width: ButtonAction.buttonGap),
                                ButtonAction(
                                    onPressed: () {
                                      analytics.logEvent(name: "Activity_Like");
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return LikeDialog(
                                                controller: _controller);
                                          });
                                    },
                                    icon: Icons.pan_tool,
                                    hero: true,
                                    coins: user.user.coins),
                              ],
                            )
                          ])))));
    });
  }
}
