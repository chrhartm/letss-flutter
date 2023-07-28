import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:letss_app/provider/followerprovider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../models/person.dart';
import '../../../provider/chatsprovider.dart';
import '../../../provider/userprovider.dart';
import '../buttons/buttonsmall.dart';
import 'tile.dart';

class ActionsTile extends StatefulWidget {
  const ActionsTile({Key? key, required this.person}) : super(key: key);
  final Person person;

  @override
  _ActionsTileState createState() => _ActionsTileState();
}

class _ActionsTileState extends State<ActionsTile> {
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
        ButtonSmall(
            text: "Share",
            padding: 0,
            onPressed: () {
              context.loaderOverlay.show();
              LinkService.shareProfile(person: person)
                  .then(
                    (value) => context.loaderOverlay.hide(),
                  )
                  .onError((error, stackTrace) => context.loaderOverlay.hide());
            }),
      ]);
    } else {
      buttons.addAll([
        Expanded(
            child: FutureBuilder<List>(
                builder: (BuildContext, _future) {
                  String text = "Follow";

                  if (_future.hasData && _future.data![0] == true) {
                    text = "Unfollow";
                  }

                  return ButtonSmall(
                      text: text,
                      onPressed: () {
                        if (text == "Follow" && _future.data![1] == false) {
                          FollowerProvider.follow(
                                  person: person, trigger: "BUTTONPRESS")
                              .then((value) => setState(() {
                                    _futures = Future.wait([
                                      FollowerProvider.amFollowing(person),
                                      UserProvider.blockedMe(person)
                                    ]);
                                  }));
                        } else if (text == "Unfollow") {
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
                builder: (BuildContext, _future) {
                  bool blocked = true;

                  if (_future.hasData && _future.data![1] == false) {
                    blocked = false;
                  }
                  return ButtonSmall(
                    text: "Message",
                    onPressed: () {
                      if (!blocked) {
                        ChatsProvider.getChatByPerson(person: person)
                            .then((chat) {
                          Navigator.pushNamed(context, "/chats/chat",
                              arguments: chat);
                        });
                      }
                    },
                  );
                },
                future: _futures)),
        ButtonSmall(
            text: "Share",
            padding: 0,
            onPressed: () {
              context.loaderOverlay.show();
              LinkService.shareProfile(person: person)
                  .then(
                    (value) => context.loaderOverlay.hide(),
                  )
                  .onError((error, stackTrace) => context.loaderOverlay.hide());
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
