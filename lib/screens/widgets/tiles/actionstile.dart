import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:letss_app/provider/followerprovider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../../models/person.dart';
import '../../../provider/chatsprovider.dart';
import '../buttons/buttonsmall.dart';
import 'tile.dart';

class ActionsTile extends StatefulWidget {
  const ActionsTile({Key? key, required this.person}) : super(key: key);
  final Person person;

  @override
  _ActionsTileState createState() => _ActionsTileState();
}

class _ActionsTileState extends State<ActionsTile> {
  late Future<bool> _amFollowing;
  late Person person;

  @override
  void initState() {
    super.initState();
    _amFollowing = FollowerProvider.amFollowing(widget.person);
    person = widget.person;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerProvider>(builder: (context, followers, child) {
      List<Widget> buttons = [];

      if (person.isMe) {
        buttons.addAll([
          Expanded(
              child: ButtonSmall(
            text: "Followers",
            onPressed: () {
              Navigator.pushNamed(context, "/profile/followers");
            },
            padding: 0,
          )),
          Expanded(
              child: ButtonSmall(
            text: "Following",
            onPressed: () {
              Navigator.pushNamed(context, '/profile/following');
            },
          )),
          // TODO Following
          ButtonSmall(
              text: "Share",
              padding: 0,
              onPressed: () {
                context.loaderOverlay.show();
                LinkService.shareProfile(person: person)
                    .then(
                      (value) => context.loaderOverlay.hide(),
                    )
                    .onError(
                        (error, stackTrace) => context.loaderOverlay.hide());
              }),
        ]);
      } else {
        buttons.addAll([
          Expanded(
              child: FutureBuilder<bool>(
                  builder: (BuildContext, followingFuture) {
                    String text = "Follow";
                    if ((followingFuture.connectionState ==
                            ConnectionState.done) ||
                        (followingFuture.connectionState ==
                            ConnectionState.active)) {
                      if (followingFuture.hasData) {
                        if (followingFuture.data == true) {
                          text = "Unfollow";
                        }
                      }
                    }
                    return ButtonSmall(
                        text: text,
                        onPressed: () {
                          if (text == "Follow") {
                            followers
                                .follow(person: person)
                                .then((value) => setState(() {
                                      _amFollowing =
                                          FollowerProvider.amFollowing(person);
                                    }));
                          } else if (text == "Unfollow") {
                            followers
                                .unfollow(person: person)
                                .then((value) => setState(() {
                                      _amFollowing =
                                          FollowerProvider.amFollowing(person);
                                    }));
                          } else {}
                        },
                        padding: 0);
                  },
                  future: _amFollowing)),
          Expanded(
              child: ButtonSmall(
            text: "Message",
            onPressed: () {
              ChatsProvider.getChatByPerson(person: person).then((chat) {
                Navigator.pushNamed(context, "/chats/chat", arguments: chat);
              });
            },
          )),
          ButtonSmall(
              text: "Share",
              padding: 0,
              onPressed: () {
                context.loaderOverlay.show();
                LinkService.shareProfile(person: person)
                    .then(
                      (value) => context.loaderOverlay.hide(),
                    )
                    .onError(
                        (error, stackTrace) => context.loaderOverlay.hide());
              })
        ]);
      }
      return Tile(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: buttons));
    });
  }
}
