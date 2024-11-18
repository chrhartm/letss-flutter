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
    super.key,
    required this.following,
  });

  final bool following;

  Widget _buildFollower(
      Follower follower, bool clickable, BuildContext context) {
    List<Widget> widgets = [];
    // widgets.add(const SizedBox(height: 2));
    // widgets.add(Divider(color: Theme.of(context).colorScheme.primary));
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
      List<Follower> followers =
          following ? followerProvider.following : followerProvider.followers;
      bool empty = followers.isEmpty;
      if (followers.isEmpty) {
        followers.add(
          Follower(
              person: Person.emptyPerson(
                name: following
                    ? AppLocalizations.of(context)!.followNotFollowingTitle
                    : AppLocalizations.of(context)!.followNoFollowersTitle,
                job: following
                    ? AppLocalizations.of(context)!.followNotFollowingAction
                    : AppLocalizations.of(context)!.followNoFollowersAction,
              ),
              dateAdded: DateTime.now(),
              following: following),
        );
      }
      return MyScaffold(
          body: HeaderScreen(
        title: following
            ? AppLocalizations.of(context)!.following
            : AppLocalizations.of(context)!.followers,
        back: true,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
            return _buildFollower(followers[index], !empty, context);
          },
          itemCount: followers.length,
          reverse: false,
        ),
      ));
    });
  }
}
