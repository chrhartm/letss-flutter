import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:letss_app/provider/followerprovider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../models/person.dart';
import '../../../provider/chatsprovider.dart';
import '../../../provider/userprovider.dart';
import '../buttons/buttonsmall.dart';
import 'tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionsTile extends StatefulWidget {
  const ActionsTile({super.key, required this.person});
  final Person person;

  @override
  ActionsTileState createState() => ActionsTileState();
}

class ActionsTileState extends State<ActionsTile> {
  // two elements: _amFollowing, _blockedMe
  late Future<List> _futures;
  late Person person;

  @override
  void initState() {
    super.initState();
    _futures = Future.wait([
      FollowerProvider.amFollowing(widget.person),
      UserProvider.blockedMe(widget.person)
    ]);
    person = widget.person;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    if (person.isMe) {
      buttons.addAll([
        Expanded(
            child: ButtonSmall(
          text: AppLocalizations.of(context)!.followers,
          onPressed: () {
            Navigator.pushNamed(context, "/profile/followers");
          },
          padding: 0,
        )),
        Expanded(
            child: ButtonSmall(
          text: AppLocalizations.of(context)!.following,
          onPressed: () {
            Navigator.pushNamed(context, '/profile/following');
          },
        )),
        ButtonSmall(
            text: AppLocalizations.of(context)!.actionShare,
            padding: 0,
            onPressed: () {
              context.loaderOverlay.show();
              LinkService.shareProfile(
                      person: person,
                      title: AppLocalizations.of(context)!
                          .actionShareProfileTitle(person.name),
                      description: AppLocalizations.of(context)!
                          .actionShareProfileDescription(person.name),
                      prompt: AppLocalizations.of(context)!
                          .actionShareProfilePromptMe)
                  .then(
                    (value) =>
                        context.mounted ? context.loaderOverlay.hide() : null,
                  )
                  .onError((error, stackTrace) =>
                      context.mounted ? context.loaderOverlay.hide() : null);
            }),
      ]);
    } else {
      buttons.addAll([
        Expanded(
            child: FutureBuilder<List>(
                builder: (buildContext, future) {
                  String text = AppLocalizations.of(context)!.actionFollow;

                  if (future.hasData && future.data![0] == true) {
                    text = AppLocalizations.of(context)!.actionUnfollow;
                  }

                  return ButtonSmall(
                      text: text,
                      onPressed: () {
                        if (text ==
                                AppLocalizations.of(context)!.actionFollow &&
                            future.data![1] == false) {
                          FollowerProvider.follow(
                                  person: person, trigger: "BUTTONPRESS")
                              .then((value) => setState(() {
                                    _futures = Future.wait([
                                      FollowerProvider.amFollowing(person),
                                      UserProvider.blockedMe(person)
                                    ]);
                                  }));
                        } else if (text ==
                            AppLocalizations.of(context)!.actionUnfollow) {
                          FollowerProvider.unfollow(person: person)
                              .then((value) => setState(() {
                                    _futures = Future.wait([
                                      FollowerProvider.amFollowing(person),
                                      UserProvider.blockedMe(person)
                                    ]);
                                  }));
                        } else {}
                      },
                      padding: 0);
                },
                future: _futures)),
        Expanded(
            child: FutureBuilder<List>(
                builder: (buildContext, future) {
                  bool blocked = true;

                  if (future.hasData && future.data![1] == false) {
                    blocked = false;
                  }
                  return ButtonSmall(
                    text: AppLocalizations.of(context)!.actionMessage,
                    onPressed: () {
                      if (!blocked) {
                        ChatsProvider.getChatByPerson(person: person)
                            .then((chat) {
                          if (context.mounted) {
                            Navigator.pushNamed(context, "/chats/chat",
                                arguments: chat);
                          }
                        });
                      }
                    },
                  );
                },
                future: _futures)),
        ButtonSmall(
            text: AppLocalizations.of(context)!.actionShare,
            padding: 0,
            onPressed: () {
              context.loaderOverlay.show();
              LinkService.shareProfile(
                      person: person,
                      title: AppLocalizations.of(context)!
                          .actionShareProfileTitle(person.name),
                      description: AppLocalizations.of(context)!
                          .actionShareProfileDescription(person.name),
                      prompt: AppLocalizations.of(context)!
                          .actionShareProfilePromptOther(person.name))
                  .then(
                    (value) =>
                        context.mounted ? context.loaderOverlay.hide() : null,
                  )
                  .onError((error, stackTrace) =>
                      context.mounted ? context.loaderOverlay.hide() : null);
            })
      ]);
    }
    return Tile(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: buttons));
  }
}
