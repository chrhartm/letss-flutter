import 'package:flutter/material.dart';
import 'package:letss_app/backend/linkservice.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../models/person.dart';
import '../../../provider/chatsprovider.dart';
import '../buttons/buttonsmall.dart';
import 'tile.dart';

class ActionsTile extends StatelessWidget {
  const ActionsTile({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    if (person.isMe) {
      buttons.addAll([
        Expanded(
            child: ButtonSmall(
          text: "Followers",
          onPressed: () {},
          padding: 0,
        )),
        // TODO Followers
        Expanded(
            child: ButtonSmall(
          text: "Following",
          onPressed: () {},
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
                  .onError((error, stackTrace) => context.loaderOverlay.hide());
            }),
      ]);
    } else {
      buttons.addAll([
        Expanded(
            child: ButtonSmall(
          text: "Follow",
          onPressed: () {},
          padding: 0,
        )),
        // TODO follow and make dynamic based on if following
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
