import 'package:flutter/material.dart';
import 'package:letss_app/models/activity.dart';
import 'package:letss_app/provider/likesprovider.dart';
import 'package:letss_app/screens/editactivityname.dart';
import 'package:provider/provider.dart';
import '../widgets/activitycard.dart';
import '../widgets/textheaderscreen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Consumer<LikesProvider>(builder: (context, likes, child) {
      return Scaffold(
          body: SafeArea(
              child: TextHeaderScreen(
                  header: activity.name,
                  back: true,
                  child: Scaffold(
                      body: ActivityCard(activity: activity, withTitle: false),
                      floatingActionButton: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.grey,
                                  heroTag: null,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FloatingActionButton(
                                        onPressed: () {},
                                        child: Icon(
                                          Icons.archive,
                                          color: Colors.white,
                                        ),
                                        heroTag: null,
                                        backgroundColor: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      FloatingActionButton(
                                        onPressed: () {
                                          // TODO activityindex needed here
                                          likes.editActiviyIndex = 1;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditActivityName()));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      )
                                    ])
                              ],
                            ),
                          ))))));
    });
  }
}
