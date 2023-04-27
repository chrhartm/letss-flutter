import 'package:flutter/material.dart';
import 'package:letss_app/provider/navigationprovider.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/myactivities/blockuserdialog.dart';
import 'package:letss_app/screens/widgets/tiles/flagtile.dart';
import 'package:provider/provider.dart';

import '../widgets/tiles/textheaderscreen.dart';
import '../../models/activity.dart';
import '../../models/like.dart';
import '../../models/person.dart';
import '../chats/widgets/messagetile.dart';
import '../widgets/tiles/texttile.dart';
import '../widgets/tiles/tagtile.dart';
import '../widgets/tiles/profilepictile.dart';
import '../widgets/tiles/nametile.dart';
import '../../provider/myactivitiesprovider.dart';
import '../widgets/buttons/buttonaction.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({
    Key? key,
    required this.activity,
    required this.like,
  }) : super(key: key);

  final Activity activity;
  final Like like;

  @override
  Widget build(BuildContext context) {
    Person person = like.person;

    return Consumer<MyActivitiesProvider>(
        builder: (context, activities, child) {
      List<Widget> buttons = [
        ButtonAction(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return BlockUserDialog(like: like);
                  });
            },
            icon: Icons.not_interested),
        const SizedBox(height: ButtonAction.buttonGap),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ButtonAction(
                  onPressed: () {
                    activities.passLike(like: like);
                    Navigator.pop(context);
                  },
                  icon: Icons.horizontal_rule),
              const SizedBox(width: 8),
              ButtonAction(
                  onPressed: () {
                    activities.confirmLike(activity: activity, like: like);
                    Navigator.pop(context);
                    Provider.of<NavigationProvider>(context, listen: false)
                        .navigateTo('/chats');
                  },
                  icon: Icons.chat_bubble,
                  heroTag: "chat")
            ])
      ];

      List<Widget> tiles = [
        const SizedBox(height: 5),
        MessageTile(text: like.message, me: false),
        const SizedBox(height: 5),
        ProfilePicTile(title: "user picture", person: person),
        const SizedBox(height: 5),
        NameTile(person: person)
      ];
      if (person.hasBio) {
        tiles.add(const SizedBox(height: 5));
        tiles.add(TextTile(title: "bio", text: person.bio!));
      }
      if (person.hasInterests) {
        tiles.add(const SizedBox(height: 5));
        tiles.add(TagTile(tags: person.interests!, interests: true));
      }
      tiles.add(FlagTile(
          flagger:
              Provider.of<UserProvider>(context, listen: false).user.person,
          flagged: activity.person,
          activity: activity));
      tiles.add(const SizedBox(height: 150));

      return Scaffold(
          body: SafeArea(
              child: TextHeaderScreen(
                  header: activity.name,
                  back: true,
                  underline: true,
                  child: ListView(children: tiles))),
          floatingActionButton: Padding(
            padding: ButtonAction.buttonPaddingNoMenu,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: buttons)),
          ));
    });
  }
}
