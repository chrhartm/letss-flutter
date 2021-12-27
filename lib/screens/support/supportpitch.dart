import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/screens/support/supportinfo.dart';
import 'package:letss_app/screens/widgets/tiles/textheaderscreen.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/provider/userprovider.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';

class SupportPitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SupportPitchState();
}

class SupportPitchState extends State<SupportPitch> {
  int badge = 1;
  final List<Map<String, String>> badges = [
    {"badge": "🙌", "description": "Get a thank you badge", "amount": "2"},
    {"badge": "❤️", "description": "Get a heart badge", "amount": "5"},
    {"badge": "🚀", "description": "Get a rocket badge", "amount": "10"}
  ];

  List<Widget> _buildSupportOptions() {
    List<Widget> widgets = [];
    for (int i = 0; i < badges.length; i++) {
      bool selected = i == badge;
      widgets.add(Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: selected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.background),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListTile(
              onTap: () => setState(() {
                    badge = i;
                  }),
              leading: CircleAvatar(
                child: Text(badges[i]["badge"]!,
                    style: Theme.of(context).textTheme.headline1),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              title: Text(badges[i]["description"]!),
              subtitle: Text(
                "${badges[i]["amount"]!} Euros per month",
              ))));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      return Scaffold(
          body: SafeArea(
              child: TextHeaderScreen(
                  header: 'Help us pay the bills ❤️',
                  back: true,
                  child: Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                                'We are working hard on making sure you have to spend as little time as possible on this app and as much time as possible with other people out there in the world. Support us on this mission.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          RichText(
                              text: TextSpan(
                            text: "Continue reading",
                            style: new TextStyle(color: Colors.blue),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    builder: (BuildContext context) {
                                      return SupportInfo();
                                    });
                              },
                          )),
                          const SizedBox(height: 30),
                          Text("Support us and get a badge next to your name",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4),
                          const SizedBox(height: 10),
                          Divider(thickness: 0),
                          ListTile(
                              leading: user.user.person.thumbnail,
                              title: Text(user.user.person.name +
                                  " " +
                                  badges[badge]["badge"]!),
                              subtitle: Text(user.user.person.job +
                                  ", " +
                                  user.user.person.locationString)),
                          Divider(thickness: 0),
                          const SizedBox(height: 20),
                          ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: _buildSupportOptions(),
                          ),
                        ]))),
                    const SizedBox(height: 10),
                    ButtonPrimary(
                        text: "Support",
                        onPressed: () {
                          return;
                        })
                  ]))));
    });
  }
}
