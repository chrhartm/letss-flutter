import 'package:flutter/material.dart';
import 'package:letss_app/screens/profile/widgets/followpreview.dart';
import 'package:letss_app/screens/widgets/myscaffold/myscaffold.dart';
import 'package:letss_app/screens/widgets/screens/headerscreen.dart';
import 'package:provider/provider.dart';
import '../../models/follower.dart';
import '../../models/person.dart';
import '../../provider/followerprovider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Follow extends StatelessWidget {
  const Follow({
    Key? key,
    required this.following,
  }) : super(key: key);

  final bool following;

  Widget _buildFollower(
      Follower follower, bool clickable, BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 2));
    widgets.add(Divider(color: Theme.of(context).colorScheme.primary));
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
      return MyScaffold(
          body: HeaderScreen(
        title: following
            ? AppLocalizations.of(context)!.following
            : AppLocalizations.of(context)!.followers,
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
                      _buildFollower(
                          followers.data!.elementAt(index), true, context),
                  itemCount: followers.data!.length,
                  reverse: false,
                );
              } else if (followers.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return _buildFollower(
                    Follower(
                        person: Person.emptyPerson(
                          name: following
                              ? AppLocalizations.of(context)!
                                  .followNotFollowingTitle
                              : AppLocalizations.of(context)!
                                  .followNoFollowersTitle,
                          job: following
                              ? AppLocalizations.of(context)!
                                  .followNotFollowingAction
                              : AppLocalizations.of(context)!
                                  .followNoFollowersAction,
                        ),
                        dateAdded: DateTime.now(),
                        following: following),
                    false,
                    context);
              }
            }),
      ));
    });
  }
}
