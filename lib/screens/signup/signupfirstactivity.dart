import 'package:flutter/material.dart';
import 'package:letss_app/provider/myactivitiesprovider.dart';
import 'package:provider/provider.dart';

import 'package:letss_app/screens/widgets/screens/subtitleheaderscreen.dart';
import 'package:letss_app/screens/widgets/buttons/buttonprimary.dart';

class SignUpFirstActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SubTitleHeaderScreen(
          top: "🎉",
          title: "Your profile is done",
          subtitle: "Now let's add your first activity.",
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text("✋", style: Theme.of(context).textTheme.displayLarge),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          "On this app, you get matched to others based on activities you want to do.",
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 100),
                    Text("✍️", style: Theme.of(context).textTheme.displayLarge),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text("So let's add a first one for you.",
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              ButtonPrimary(
                onPressed: () {
                  Provider.of<MyActivitiesProvider>(context, listen: false)
                      .addNewActivity(context);
                },
                text: "Let's do it",
              ),
            ],
          ),
          back: false,
        ),
      ),
    );
  }
}
