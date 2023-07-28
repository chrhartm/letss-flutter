import 'package:flutter/material.dart';
import 'package:letss_app/screens/widgets/other/textdivider.dart';
import 'package:letss_app/screens/widgets/tiles/widgets/underlined.dart';
import 'package:provider/provider.dart';

import '../../../models/like.dart';
import '../../../models/person.dart';
import '../activityscreen.dart';
import '../../../models/activity.dart';
import 'activitylike.dart';
import '../../../provider/myactivitiesprovider.dart';

class ActivityLikes extends StatelessWidget {
  const ActivityLikes({Key? key, required this.activity}) : super(key: key);

  final Activity activity;

  Widget _buildLike(Like like, bool interactive, Activity activity) {
    return (Column(children: [
      const SizedBox(height: 2),
      ActivityLike(like: like, activity: activity, interactive: interactive)
    ]));
  }

  Widget _buildJoiner({required BuildContext context, Person? person}) {
    if (person == null) {
      return (Column(children: [
        const SizedBox(height: 4),
        ListTile(
          leading: CircleAvatar(
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          title: Text(
            "Add followers",
          ),
        ),
        const SizedBox(height: 4),
      ]));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyActivitiesProvider>(
        builder: (context, myactivities, child) {
      bool collapsed = myactivities.isCollapsed(activity);
      List<Widget> widgets = [];
      widgets.add(Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Underlined(
                        text: activity.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ))),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: const RouteSettings(
                              name: '/myactivities/activity'),
                          builder: (context) =>
                              ActivityScreen(activity: activity)));
                },
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              padding: EdgeInsets.only(right: 10),
              constraints: BoxConstraints(),
              icon: Align(
                  alignment: Alignment.centerRight,
                  child: collapsed
                      ? Icon(Icons.keyboard_arrow_down)
                      : Icon(Icons.keyboard_arrow_up)),
              onPressed: () {
                myactivities.collapse(activity);
              },
            )
          ]));

      if (!collapsed) {
        widgets.add(_buildJoiner(context: context));
        widgets.add(StreamBuilder(
            stream: myactivities.likeStream(activity),
            builder:
                (BuildContext context, AsyncSnapshot<Iterable<Like>> likes) {
              if (likes.hasData && likes.data!.length > 0) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int i) {
                    if (i == likes.data!.length) {
                      return TextDivider(text: "Interested - add them to join");
                    }
                    return _buildLike(likes.data!.elementAt(i), true, activity);
                  },
                  itemCount: likes.data!.length + 1,
                  reverse: true,
                );
              } else if (likes.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return Container();
              }
            }));
      }

      return Container(
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(children: widgets)))));
    });
  }
}
