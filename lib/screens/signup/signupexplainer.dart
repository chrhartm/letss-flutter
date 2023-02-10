import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/buttonaction.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';
import 'package:provider/provider.dart';

class SignUpExplainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      ListTile(
          leading: ButtonAction(icon: Icons.pan_tool, heroTag: "like"),
          title: Text("Like"),
          subtitle: Text(
              "Like other activities and send a message. You have a daily number of likes as indicated on the button.")),
      ListTile(
          leading: ButtonAction(
            icon: Icons.horizontal_rule,
          ),
          title: Text("Not interested"),
          subtitle: Text("Skip suggested activities")),
      ListTile(
          leading: ButtonAction(icon: Icons.chat_bubble, heroTag: "chat"),
          title: Text("Chat"),
          subtitle:
              Text("If you like someone's message, you can start a chat")),
      ListTile(
          leading: ButtonAction(icon: Icons.add, heroTag: "add"),
          title: Text("Add"),
          subtitle: Text("Add your own activities for others to like")),
      ListTile(
          leading: ButtonAction(icon: Icons.edit, heroTag: "edit"),
          title: Text("Edit"),
          subtitle: Text("Edit your own activities")),
      ListTile(
          leading: ButtonAction(
              icon: Platform.isIOS ? Icons.ios_share : Icons.share),
          title: Text("Share"),
          subtitle: Text("Share activities with friends")),
      ListTile(
          leading: ButtonAction(icon: Icons.archive),
          title: Text("Archive"),
          subtitle: Text("Archive your own activity")),
      ListTile(
          leading: ButtonAction(icon: Icons.settings),
          title: Text("Settings"),
          subtitle:
              Text("Change your preferences (and see this explainer again)")),
    ];

    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "👨‍🏫",
          title: "A quick explainer",
          subtitle: "Letss is very simple, these are the key buttons",
          child: Column(
            children: [
              Expanded(
                  child: Column(children: [
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      // Get padding at bottom
                      if (index == items.length) {
                        return Container();
                      }
                      return items[index];
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                  ),
                ),
              ])),
              ButtonPrimary(
                onPressed: () {
                  UserProvider user =
                      Provider.of<UserProvider>(context, listen: false);
                  user.user.finishedSignupFlow = true;
                  user.forceNotify();
                  Navigator.popUntil(
                      context, (Route<dynamic> route) => route.isFirst);
                },
                text: "Let's go",
              ),
            ],
          ),
          back: true,
        ),
      ),
    );
  }
}
