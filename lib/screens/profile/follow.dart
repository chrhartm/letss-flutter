import 'package:flutter/material.dart';
import 'package:letss_app/screens/profile/widgets/followpreview.dart';
import 'package:provider/provider.dart';
import '../../models/follower.dart';
import '../../models/person.dart';
import '../../provider/followerprovider.dart';
import '../widgets/tiles/textheaderscreen.dart';

class Follow extends StatelessWidget {
  const Follow({
    Key? key,
    required this.following,
  }) : super(key: key);

  final bool following;

  Widget _buildFollower(Follower follower, bool clickable) {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 2));
    widgets.add(Divider());
    widgets.add(const SizedBox(height: 2));
    widgets.add(FollowPreview(
      follower: follower,
      following: following,
      clickable: clickable,
    ));

    return Column(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowerProvider>(
        builder: (context, followerProvider, child) {
      return Scaffold(
          body: SafeArea(
              child: TextHeaderScreen(
        header: following ? "Following" : "Followers",
        back: true,
        child: StreamBuilder(
            stream: following
                ? followerProvider.followingStream
                : followerProvider.followerStream,
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<Follower>> followers) {
              if (followers.hasData && followers.data!.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int index) =>
                      _buildFollower(followers.data!.elementAt(index), true),
                  itemCount: followers.data!.length,
                  reverse: false,
                );
              } else if (followers.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return _buildFollower(
                    Follower(
                        person: Person.emptyPerson(
                            name: (following
                                ? "You are not following anybody"
                                : "We will show followers here"),
                            job: (following
                                ? "Click follow on profiles to add them"
                                : "Share your profile with friends")),
                        dateAdded: DateTime.now(),
                        following: following),
                    false);
              }
            }),
      )));
    });
  }
}
